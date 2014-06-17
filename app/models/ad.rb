class Ad < ActiveRecord::Base
	extend Enumerize
	enumerize :status, :in => [:draft, :new, :rejected, :approved, :published, :archive], scope: true
	belongs_to :ad_type, inverse_of: :ads
end
