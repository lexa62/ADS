class AdType < ActiveRecord::Base
  before_destroy :can_delete?

  validates :name, presence: true, length: { maximum: 15 }
  has_many :ads, inverse_of: :ad_type, dependent: :destroy

  def can_delete?
    ads.empty?
  end
end
