class Image < ActiveRecord::Base
  has_attached_file :file, :styles => { :small => "150x150>" }
  belongs_to :ad
  validates_attachment_content_type :file, :content_type => /\Aimage\/.*\Z/
end
