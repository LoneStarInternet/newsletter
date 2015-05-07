class AddStylesheetTextToDesigns < ActiveRecord::Migration
  def table_prefix
    table_prefix = 'newsletter_'
    begin
      table_prefix = ::Newsletter.table_prefix
    rescue
    end
  end
  def change
    add_column :"#{table_prefix}designs", :stylesheet_text, :text
  end
end
