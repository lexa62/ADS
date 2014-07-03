class AddAdRefToImages < ActiveRecord::Migration
  def change
    add_reference :images, :ad, index: true
  end
end
