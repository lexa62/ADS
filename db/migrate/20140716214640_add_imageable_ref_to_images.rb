require_relative '20140626212051_add_ad_ref_to_images'

class AddImageableRefToImages < ActiveRecord::Migration
  def change
    revert AddAdRefToImages

    add_reference :images, :imageable, polymorphic: true
  end
end
