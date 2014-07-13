require 'rails_helper'
require 'spec_helper'

describe User do
  describe "fields" do
    subject { Fabricate(:user) }

    it { is_expected.to respond_to(:email) }
    it { is_expected.to respond_to(:password) }
    it { is_expected.to respond_to(:role) }
    it { is_expected.to be_valid }

    describe "email format" do
      let(:user) { Fabricate(:user) }

      it "is invalid when missing the point" do
        user.email = 'user@foo,com'
        expect(user).not_to be_valid
      end

      it "is invalid when missing @" do
        user.email = 'user_at_foo.org'
        expect(user).not_to be_valid
      end

      it "is invalid when missing domain" do
        user.email = 'example.user@foo.'
        expect(user).not_to be_valid
      end
    end

    describe "password format" do
      let(:user) { Fabricate(:user) }

      it "is invalid when password is not present" do
        user.password = ' '
        user.password_confirmation = ' '
        expect(user).not_to be_valid
      end
    end
  end
end
