class NewsletterInitial < ActiveRecord::Migration
  def self.up
    table_prefix = 'newsletter_'
    begin
      table_prefix = ::Newsletter.table_prefix
    rescue
    end
    create_table :"#{table_prefix}designs" do |t|
      t.string :name, :null => false
      t.string :description
      t.text :html_design
      t.integer :updated_by
      t.datetime :deleted_at
      t.timestamps
    end
    create_table :"#{table_prefix}areas" do |t|
      t.string :name, :null => false
      t.string :description
      t.integer :design_id
      t.integer :updated_by
      t.datetime :deleted_at
      t.timestamps
    end
    create_table :"#{table_prefix}elements" do |t|
      t.string :name, :null => false
      t.string :description
      t.text :html_design
      t.integer :design_id
      t.integer :updated_by
      t.datetime :deleted_at
      t.timestamps
    end
    create_table :"#{table_prefix}areas_#{table_prefix}elements", :id => false do |t|
      t.integer :area_id, :null => false
      t.integer :element_id, :null => false
    end
    create_table :"#{table_prefix}fields" do |t|
      t.string :name, :null => false
      t.integer :element_id, :null => false
      t.string :label
      t.integer :sequence
      t.boolean :is_required
      t.string :description
      t.string :type
      t.integer :updated_by
      t.datetime :deleted_at
      t.timestamps
    end
    create_table :"#{table_prefix}newsletters" do |t|
      t.string :name, :null => false
      t.string :description
      t.integer :design_id
      t.integer :sequence
      t.datetime :published_at
      t.integer :updated_by
      t.datetime :deleted_at
      t.timestamps
    end
    create_table :"#{table_prefix}pieces" do |t|
      t.integer :newsletter_id, :null => false
      t.integer :area_id, :null => false
      t.integer :element_id, :null => false
      t.integer :sequence, :null => false
      t.integer :updated_by
      t.datetime :deleted_at
      t.timestamps
    end
    create_table :"#{table_prefix}field_values" do |t|
      t.integer :piece_id, :null => false
      t.integer :field_id, :null => false
      t.string :key, :null => false
      t.text :value, :null => false
      t.integer :updated_by
      t.datetime :deleted_at
      t.timestamps
    end
    create_table :"#{table_prefix}assets" do |t|
      t.integer :field_id
      t.integer :piece_id
      t.string :filename
      t.string :content_type
      t.integer :size
      t.integer :width
      t.integer :height
      t.integer :parent_id
      t.string :thumbnail
      t.integer :updated_by
      t.datetime :deleted_at
      t.timestamps
    end
  end

  def self.down
    drop_table :"#{table_prefix}assets"
    drop_table :"#{table_prefix}field_values"
    drop_table :"#{table_prefix}pieces"
    drop_table :"#{table_prefix}newsletters"
    drop_table :"#{table_prefix}fields"
    drop_table :"#{table_prefix}areas_#{table_prefix}elements"
    drop_table :"#{table_prefix}elements"
    drop_table :"#{table_prefix}areas"
    drop_table :"#{table_prefix}designs"
  end
end