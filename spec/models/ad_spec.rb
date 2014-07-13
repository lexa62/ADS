require 'rails_helper'
require 'spec_helper'

describe Ad do
  describe "fields" do
    let(:user) { Fabricate(:user) }
    let(:ad_type) { Fabricate(:ad_type) }
    subject(:ad) { Fabricate(:ad, ad_type: ad_type, user: user) }

    it { is_expected.to respond_to(:title) }
    it { is_expected.to respond_to(:text) }
    it { is_expected.to respond_to(:price) }
    it { is_expected.to respond_to(:user) }
    it { is_expected.to respond_to(:ad_type) }

    it { is_expected.to be_valid }

    describe "price format" do
      it "is invalid when price isn't an integer" do
        ad.price = 123.123
        expect(ad).not_to be_valid
      end

      it "is invalid when price is larger than 1 million" do
        ad.price = 10_000_000
        expect(ad).not_to be_valid
      end
    end
  end

  context 'in draft state' do
    let(:user) { Fabricate(:user) }
    let(:ad_type) { Fabricate(:ad_type) }
    let(:ad) { Fabricate(:ad, ad_type: ad_type, user: user) }

    it 'can not be transferred to any state except new' do
      events = ['moderating', 'publish', 'in_archive', 'reject_ad', 'approve_ad', 'make_draft', 'edit_rejected_ad']
      array = []
      events.each do |event|
        ad.status = 'draft'
        ad.send(event)
        array << ad.status.in?(['draft', 'new'])
      end

      expect(array).not_to include(false)
    end

    it 'transferring to new state by #moderating' do
      ad.moderating
      expect(ad).to be_new
    end

    it "doesn't respond to events other than #moderating" do
      events = ['publish', 'in_archive', 'reject_ad', 'approve_ad', 'make_draft', 'edit_rejected_ad']
      array = []
      events.each do |event|
        array << ad.send(event)
      end

      expect(array).not_to include(true)
    end
  end

  context 'in new state' do
    let(:user) { Fabricate(:user) }
    let(:ad_type) { Fabricate(:ad_type) }
    let(:ad) { Fabricate(:ad, ad_type: ad_type, user: user, status: 'new') }

    it 'can not be transferred to any state except rejected and approved' do
      events = ['moderating', 'publish', 'in_archive', 'reject_ad', 'approve_ad', 'make_draft', 'edit_rejected_ad']
      array = []
      events.each do |event|
        ad.status = 'new'
        ad.send(event)
        array << ad.status.in?(['new', 'rejected', 'approved'])
      end

      expect(array).not_to include(false)
    end

    it 'transferring to rejected state by #reject_ad' do
      ad.reject_ad
      expect(ad).to be_rejected
    end

    it 'transferring to approved state by #approve_ad' do
      ad.approve_ad
      expect(ad).to be_approved
    end

    it "doesn't respond to events other than #reject_ad or #approve_ad" do
      events = ['moderating', 'publish', 'in_archive', 'make_draft', 'edit_rejected_ad']
      array = []
      events.each do |event|
        array << ad.send(event)
      end

      expect(array).not_to include(true)
    end
  end
end
