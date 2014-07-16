require 'rails_helper'

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
      let(:ad_type) { Fabricate(:ad_type, name: 'IT') }

      before(:each) do
        login_as(user, :scope => :user)
      end

      describe "by creating new ad" do
        it "display created ad in dashboard" do
          Fabricate(:ad, user: user, ad_type: ad_type, title: 'first_ad')
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
          Fabricate(:ad, user: user, ad_type: ad_type, title: 'first_ad')
          visit my_ads_path
          click_link "Edit"
          fill_in "Title", :with => "ttt"
          click_button "Save"
          visit my_ads_path
          expect(page).to have_content("ttt")
        end
      end

      describe "by change ad's state on new" do
        it "display new state of ad" do
          Fabricate(:ad, user: user, ad_type: ad_type, title: 'first_ad')
          visit my_ads_path
          click_link "Moderating"
          expect(page).to have_content("new")
        end
      end

      describe "by change ad's state on draft" do
        it "display draft state of ad" do
          Fabricate(:ad, user: user, ad_type: ad_type, title: 'second_ad', status: 'rejected')
          visit my_ads_path
          click_link "Move in drafts"
          expect(page).to have_content("draft")
        end
      end

      describe "by search ad" do
        it "display needed ad" do
          Fabricate(:ad, user: user, ad_type: ad_type, title: 'first_ad', status: 'published')
          Fabricate(:ad, user: user, ad_type: ad_type, title: 'second_ad', status: 'published')
          visit root_path
          fill_in "Title contains", :with => "first_ad"
          click_on "Search"
          # first tr - name of ad's fields, second tr - ad with title first_ad
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

      describe "by use filter for ads" do
        it "display filtered ads " do
          another_ad_type = Fabricate(:ad_type, name: 'Cars')
          3.times { Fabricate(:ad, user: user, ad_type: another_ad_type, title: 'first_ad', status: 'published') }
          5.times { Fabricate(:ad, user: user, ad_type: ad_type, title: 'first_ad', status: 'published') }
          visit root_path
          click_link "Cars"
          # first tr - name of ad's fields, next tr's - ads with type Cars
          expect(page).to have_selector('table tr', count: 4)
        end
      end
    end
  end

  context "when admin" do
    describe "check routes" do

      before(:each) do
        user = Fabricate(:user, role: 'admin')
        login_as(user, :scope => :user)
      end

      describe "by visiting /ads/new" do
        it "response status not Ok" do
          get new_ad_path
          expect(response.status).not_to be(200)
        end
      end

      describe "by visiting /my_ads" do
        it "response status not Ok" do
          get my_ads_path
          expect(response.status).not_to be(200)
        end
      end

      describe "by visiting /admin/ads" do
        it "response status not Ok" do
          get admin_ads_path
          expect(response.status).to be(200)
        end
      end

      describe "by visiting /admin/users" do
        it "response status not Ok" do
          get admin_users_path
          expect(response.status).to be(200)
        end
      end
    end

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
