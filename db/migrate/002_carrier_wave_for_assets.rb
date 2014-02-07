class CarrierWaveForAssets < ActiveRecord::Migration
  def up
    rename_column :newsletter_assets, :filename, :image
  end

  def down
    rename_column :newsletter_assets, :image, :filename
  end
end
