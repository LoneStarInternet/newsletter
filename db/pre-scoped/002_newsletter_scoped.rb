class NewsletterScoped < ActiveRecord::Migration
  def self.up
    rename_column :newsletter_areas, :newsletter_template_id, :design_id
    rename_column :newsletter_elements, :newsletter_template_id, :design_id
    rename_column :newsletter_areas_newsletter_elements, :newsletter_area_id, :area_id
    rename_column :newsletter_areas_newsletter_elements, :newsletter_element_id, :element_id
    rename_column :newsletter_fields, :newsletter_element_id, :element_id
    rename_column :newsletters, :newsletter_template_id, :design_id
    rename_column :newsletter_pieces, :newsletter_area_id, :area_id
    rename_column :newsletter_pieces, :newsletter_element_id, :element_id
    rename_column :newsletter_field_values, :newsletter_piece_id, :piece_id
    rename_column :newsletter_field_values, :newsletter_field_id, :field_id
    rename_column :newsletter_assets, :newsletter_field_id, :field_id
    rename_column :newsletter_assets, :newsletter_piece_id, :piece_id
    rename_table :newsletters, :newsletter_newsletters
    rename_table :newsletter_templates, :newsletter_designs
    conn = ActiveRecord::Base.connection
    conn.execute("UPDATE `mlm_mailings`
      SET mailable_type='Newsletter::Newsletter'
      WHERE mailable_type='Newsletter'")
    ["InlineAsset","Text","TextArea"].each do |type|
      conn.execute("UPDATE newsletter_fields
        SET type='Newsletter::Field::#{type}'
        WHERE type='NewsletterField::#{type}'")
    end
  end
  
  def self.down
    rename_column :newsletter_areas, :design_id, :newsletter_template_id
    rename_column :newsletter_elements, :design_id, :newsletter_template_id
    rename_column :newsletter_areas_newsletter_elements, :area_id, :newsletter_area_id
    rename_column :newsletter_areas_newsletter_elements, :element_id, :newsletter_element_id
    rename_column :newsletter_fields, :element_id, :newsletter_element_id
    rename_column :newsletters, :design_id, :newsletter_template_id
    rename_column :newsletter_pieces, :area_id, :newsletter_area_id
    rename_column :newsletter_pieces, :element_id, :newsletter_element_id
    rename_column :newsletter_field_values, :piece_id, :newsletter_piece_id
    rename_column :newsletter_field_values, :field_id, :newsletter_field_id
    rename_column :newsletter_assets, :field_id, :newsletter_field_id
    rename_column :newsletter_assets, :piece_id, :newsletter_piece_id
    rename_table :newsletter_newsletters, :newsletters
    rename_table :newsletter_designs, :newsletter_templates
    conn = ActiveRecord::Base.connection
    conn.execute("UPDATE `mlm_mailings`
      SET mailable_type='Newsletter'
      WHERE mailable_type='Newsletter::Newsletter'")
    ["InlineAsset","Text","TextArea"].each do |type|
      conn.execute("UPDATE newsletter_fields
        SET type='NewsletterField::#{type}'
        WHERE type='Newsletter::Field::#{type}'")
    end
    menu = AdminMenu.find_by_description('Create/Manage')
    menu.update_attributes(:path => 'admin/newsletters',
      :description => 'Newsletters') unless menu.nil?
    menu = AdminMenu.find_by_description('Newsletter')
    menu.update_attributes(:path => 'admin/newsletters') unless menu.nil?
    menu = AdminMenu.find_by_description('Designs')
    menu.update_attributes(:path => 'admin/newsletter_templates',
      :description => 'Newsletter Templates') unless menu.nil?
  end
end