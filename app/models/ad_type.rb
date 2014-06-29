class AdType < ActiveRecord::Base
  validates :name, presence: true, length: { maximum: 15 }
  has_many :ads, inverse_of: :ad_type

  def can_delete?
    ads.count == 0
  end
end
