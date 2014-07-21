class AddAdsCountToAdTypes < ActiveRecord::Migration

  def self.up

    add_column :ad_types, :ads_count, :integer, :null => false, :default => 0

  end

  def self.down

    remove_column :ad_types, :ads_count

  end

end
