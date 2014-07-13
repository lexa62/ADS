require 'rails_helper'
require 'spec_helper'

describe AdType do
  describe "fields" do
    let(:ad_type) { Fabricate(:ad_type) }

    it "is respond to name" do
      expect(ad_type).to respond_to(:name)
    end

    it "is invalid when name is too long" do
      ad_type.name = "a" * 51
      expect(ad_type).to_not be_valid
    end
  end
end
