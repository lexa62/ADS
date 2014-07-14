class AdType < ActiveRecord::Base
  validates :name, presence: true, length: { maximum: 15 }
  has_many :ads, inverse_of: :ad_type, dependent: :restrict_with_error

  def can_delete?
    ads.empty?
  end
end
