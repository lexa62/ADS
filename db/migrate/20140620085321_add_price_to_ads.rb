class AddPriceToAds < ActiveRecord::Migration
  def change
    add_column :ads, :price, :decimal, :precision => 6, :scale => 0
  end
end
