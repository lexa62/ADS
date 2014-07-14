require 'rails_helper'
require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

describe "Ads" do
  context "when user" do
    describe "visit /ads/new" do
      it "need to work" do
        user = Fabricate(:user)
        login_as(user, :scope => :user)
        get new_ad_path
        expect(response.status).to be(200)
      end
    end

    describe "visit /my_ads" do
      it "need to work" do
        user = Fabricate(:user)
        login_as(user, :scope => :user)
        get my_ads_path
        expect(response.status).to be(200)
      end
    end

    describe "create new ad" do
      it "display created ad in dashboard" do
        user = Fabricate(:user)
        login_as(user, :scope => :user)
        ad_type = Fabricate(:ad_type)
        ad = Fabricate(:ad, user: user, ad_type: ad_type, title: 'piydsf')
        visit my_ads_path
        expect(page).to have_content("piydsf")
      end
    end

    describe "edit new ad" do
      it "display edited ad in dashboard" do
        user = Fabricate(:user)
        login_as(user, :scope => :user)
        ad_type = Fabricate(:ad_type)
        ad = Fabricate(:ad, user: user, ad_type: ad_type, title: 'piydsf')
        visit my_ads_path
        click_link "Edit"
        fill_in "Title", :with => "ghj"
        click_button "Save"
        visit my_ads_path
        expect(page).to have_content("ghj")
      end
    end
  end
end
