class AddUserRefToAds < ActiveRecord::Migration
  def change
    add_reference :ads, :user, index: true
  end
end
