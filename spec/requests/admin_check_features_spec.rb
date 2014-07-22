require 'rails_helper'

include Warden::Test::Helpers
Warden.test_mode!

describe "Ads" do
  context "when admin" do
    describe "check features" do
      let(:user) { Fabricate(:user, role: 'admin') }
      let(:ad_type) { Fabricate(:ad_type) }

      before(:each) do
        login_as(user, :scope => :user)
      end

      describe "by creating new ad_type" do
        it "display created ad_type" do
          visit new_admin_ad_type_path
          fill_in "Name", :with => "12345"
          click_button "Save"
          visit admin_ad_types_path

          expect(page).to have_content("12345")
        end
      end

      describe "by creating new user" do
        it "display created user" do
          visit new_admin_user_path
          fill_in "Email", :with => "123@123.com"
          fill_in "Password", :with => "123123123"
          fill_in "Re-enter Password", :with => "123123123"
          click_button "Save"
          visit admin_users_path

          expect(page).to have_content("123@123.com")
        end
      end

      describe "by change ad's state on approved" do
        it "display approved state of ad" do
          Fabricate(:ad, user: user, ad_type: ad_type, title: 'first_ad', status: 'new')

          visit admin_ads_path
          click_link "Approve"

          expect(page).to have_content("approved")
        end
      end

      describe "by change ad's state on rejected" do
        it "display rejected state of ad" do
          Fabricate(:ad, user: user, ad_type: ad_type, title: 'second_ad', status: 'new')

          visit admin_ads_path
          click_link "Ban"

          expect(page).to have_content("rejected")
        end
      end

      describe "by search ad" do
        it "display needed ad" do
          Fabricate(:ad, user: user, ad_type: ad_type, title: 'first_ad', status: 'published')
          Fabricate(:ad, user: user, ad_type: ad_type, title: 'second_ad', status: 'published')

          visit root_path
          fill_in "Title contains", :with => "first_ad"
          click_on "Search"

          #first tr - name of ad's fields, second tr - ad with title first_ad
          expect(page).to have_selector('table tr', count: 2)
        end
      end

      describe "by change ad's tille sort order" do
        it "display asc order" do
          ad1 = Fabricate(:ad, user: user, ad_type: ad_type, title: 'title_#1', status: 'published')
          ad2 = Fabricate(:ad, user: user, ad_type: ad_type, title: 'title_#2', status: 'published')

          visit root_path
          click_link "Title"

          expect(ad1.title).to appear_before(ad2.title)
        end

        it "display desc order" do
          ad1 = Fabricate(:ad, user: user, ad_type: ad_type, title: 'title_#1', status: 'published')
          ad2 = Fabricate(:ad, user: user, ad_type: ad_type, title: 'title_#2', status: 'published')

          visit root_path
          2.times { click_link "Title" }

          expect(ad2.title).to appear_before(ad1.title)
        end
      end
    end
  end
end
