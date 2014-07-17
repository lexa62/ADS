class Image < ActiveRecord::Base
  has_attached_file :file, :styles => { :small => "150x150>" }, default_url: '/images/:style/missing.png'
  belongs_to :imageable, polymorphic: true
  validates_attachment_content_type :file, :content_type => /\Aimage\/.*\Z/
end
