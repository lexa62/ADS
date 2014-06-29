require 'rails_helper'
require 'spec_helper'

describe AdType do

  subject (:ad_type) { AdType.new(name: "test") }

  it { should respond_to(:name) }

  describe "when name is too long" do
    before { ad_type.name = "a" * 51 }
    it { should_not be_valid }
  end
end