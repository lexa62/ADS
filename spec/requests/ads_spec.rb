require 'rails_helper'
require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

describe "Ads" do
  context "when user" do
    describe "check routes" do

      before(:each) do
        user = Fabricate(:user)
        login_as(user, :scope => :user)
      end

      describe "by visiting /ads/new" do
        it "response status Ok" do
          get new_ad_path
          expect(response.status).to be(200)
        end
      end

      describe "by visiting /my_ads" do
        it "response status Ok" do
          get my_ads_path
          expect(response.status).to be(200)
        end
      end
    end

    describe "check features" do
      let(:user) { Fabricate(:user) }
      let(:ad_type) { Fabricate(:ad_type) }

      before(:each) do
        login_as(user, :scope => :user)
        Fabricate(:ad, user: user, ad_type: ad_type, title: 'first_ad')
      end

      describe "by creating new ad" do
        it "display created ad in dashboard" do
          visit new_ad_path
          fill_in "Title", :with => "12345"
          fill_in "Text", :with => "ghj"
          fill_in "Price", :with => 555
          find('#ad_ad_type_id').find(:xpath, 'option[2]').select_option
          click_button "Save"
          visit my_ads_path
          expect(page).to have_content("12345")
        end
      end

      describe "by editing new ad" do
        it "display edited ad in dashboard" do
          visit my_ads_path
          click_link "Edit"
          fill_in "Title", :with => "ttt"
          click_button "Save"
          visit my_ads_path
          expect(page).to have_content("ttt")
        end
      end
    end
  end
end
