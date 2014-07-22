require 'rails_helper'

include Warden::Test::Helpers
Warden.test_mode!

describe "Ads" do
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
        it "response status Ok" do
          get admin_ads_path
          expect(response.status).to be(200)
        end
      end
    end
  end
end
