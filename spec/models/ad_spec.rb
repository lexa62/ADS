require 'rails_helper'
require 'spec_helper'

describe Ad do

  before :each do
    @ad = Ad.new(title: "123", text: "123", price: 123, user_id: 1, ad_type_id: 1)
  end

  subject { @ad }

  it { should respond_to(:title) }
  it { should respond_to(:text) }
  it { should respond_to(:price) }
  it { should respond_to(:user) }
  it { should respond_to(:ad_type) }

  it { should be_valid }

  describe "when price format is invalid" do
    it "should be invalid" do
      prices = [123.123, 10_000_000]
      prices.each do |invalid_price|
        @ad.price = invalid_price
        expect(@ad).not_to be_valid
      end
    end
  end

  describe 'states' do
    describe ':draft' do
      it 'should be an initial state' do
        @ad.should be_draft
      end

      it 'should change to :new on :moderating' do
        @ad.moderating
        @ad.should be_new
      end

      it 'should change to :approved on :approve_ad' do
        @ad.status = "new"
        @ad.approve_ad
        @ad.should be_approved
      end

      it 'should change to :rejected on :reject_ad' do
        @ad.status = "new"
        @ad.reject_ad
        @ad.should be_rejected
      end

      it 'should change to :published on :publish' do
        @ad.status = "published"
        @ad.in_archive
        @ad.should be_archive
      end

      it 'should change to :archive on :in_archive' do
        @ad.status = "approved"
        @ad.publish
        @ad.should be_published
      end

      it 'should change to :draft on :make_draft' do
        @ad.status = "archive"
        @ad.make_draft
        @ad.should be_draft
      end

      it 'should change to :draft on :edit_rejected_ad' do
        @ad.status = "rejected"
        @ad.edit_rejected_ad
        @ad.should be_draft
      end

      ['publish', 'in_archive', 'reject_ad', 'approve_ad', 'make_draft', 'edit_rejected_ad'].each do |action|
        it "should return false for #{action}" do
          @ad.send(action).should == false
        end
      end
    end
  end
end
