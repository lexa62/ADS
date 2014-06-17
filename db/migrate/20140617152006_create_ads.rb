class CreateAds < ActiveRecord::Migration
  def change
    create_table :ads do |t|
      t.string :title
      t.text :text
      t.string :status
      t.references :ad_type

      t.timestamps
    end
  end
end
