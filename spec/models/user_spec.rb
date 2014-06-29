require 'rails_helper'
require 'spec_helper'
require "cancan/matchers"

describe User do
  before do
    @user = User.new(email: "user@example.com", password: "123123123", password_confirmation: "123123123", role: "user")
  end

  describe "fields" do
    subject { @user }

    it { should respond_to(:email) }
    it { should respond_to(:password) }
    it { should respond_to(:role) }
    it { should be_valid }

    describe "when email format is invalid" do
      it "should be invalid" do
        addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
        addresses.each do |invalid_address|
          @user.email = invalid_address
          expect(@user).not_to be_valid
        end
      end
    end

    describe "when password is not present" do
      before { @user.password = @user.password_confirmation = " " }
      it { should_not be_valid }
    end
  end

  describe "abilities" do
    subject(:ability){ Ability.new(user) }

    context "when is a user" do
      let(:user){ User.new(email: "user@example.com", password: "123123123", password_confirmation: "123123123", role: "user") }

      it { should be_able_to(:read, Ad.new) }
      it { should be_able_to(:create, Ad.new) }
      it { should be_able_to(:manipulate, Ad.new(:user => user)) }
      it { should be_able_to(:update, Ad.new(:user => user, :status => "draft")) }
      it { should be_able_to(:destroy, Ad.new(:user => user)) }

      it { should_not be_able_to(:destroy, Ad.new(:user_id => 10)) }
      it { should_not be_able_to(:update, Ad.new(:user => user, :status => "new")) }
      it { should_not be_able_to(:manipulate, Ad.new(:user_id => 10)) }
    end

    context "when is an admin" do
      let(:user){ User.new(email: "admin@admin.com", password: "123123123", password_confirmation: "123123123", role: "admin") }

      it { should be_able_to(:manage, AdType.new) }
      it { should be_able_to(:manage, User.new) }
      it { should be_able_to(:destroy, Ad.new(:status => "new"))}

      it { should_not be_able_to(:destroy, Ad.new(:status => "draft"))}
    end
  end
end
