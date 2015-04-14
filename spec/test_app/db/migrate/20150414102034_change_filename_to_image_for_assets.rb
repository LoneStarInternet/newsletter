class ChangeFilenameToImageForAssets < ActiveRecord::Migration
  def up
    rename_column "#{table_prefix}assets", :filename, :image
  end

  def down
    rename_column "#{table_prefix}assets", :image, :filename
  end

  def table_prefix
    table_prefix = 'newsletter_'
    begin
      table_prefix = ::Newsletter.table_prefix
    rescue
    end
    table_prefix
  end
end
