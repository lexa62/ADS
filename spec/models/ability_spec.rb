require 'rails_helper'
require 'spec_helper'
require "cancan/matchers"

describe Ability do
  subject(:ability) { Ability.new(user) }
  let(:user) { nil }

  context "when is an user" do
    let(:user) { Fabricate(:user) }
    let(:another_user) { Fabricate(:user) }
    let(:ad_type) { Fabricate(:ad_type) }
    let(:ad) { Fabricate(:ad, ad_type: ad_type, user: user) }
    let(:another_ad) { Fabricate(:ad, ad_type: ad_type, user: another_user) }

    it { is_expected.to be_able_to(:read, ad) }
    it { is_expected.to be_able_to(:create, ad) }
    it { is_expected.to be_able_to(:manipulate, ad) }
    it { is_expected.to be_able_to(:update, ad) }
    it { is_expected.to be_able_to(:destroy, ad) }

    it { is_expected.to_not be_able_to(:destroy, another_ad) }
    it { is_expected.to_not be_able_to(:manipulate, another_ad) }
  end

  context "when is an admin" do
    let(:user) { Fabricate(:user, role: 'admin') }
    let(:ad_type) { Fabricate(:ad_type) }
    let(:ad) { Fabricate(:ad, ad_type: ad_type, user: user) }

    it { is_expected.to be_able_to(:manage, ad_type) }
    it { is_expected.to be_able_to(:manage, user) }
    it { is_expected.not_to be_able_to(:destroy, ad) }
  end
end
