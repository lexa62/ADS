class AdType < ActiveRecord::Base
	has_many :ads, inverse_of: :ad_type
end
