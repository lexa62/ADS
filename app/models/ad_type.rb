class AdType < ActiveRecord::Base
  has_many :ads, inverse_of: :ad_type

  def can_delete?
    ads.count == 0
  end
end
