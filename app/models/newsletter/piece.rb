=begin rdoc
Author::    Chris Hauboldt (mailto:biz@lnstar.com)
Copyright:: 2009 Lone Star Internet Inc.

NewsletterPieces are the glue that tie data together to form a piece in an area of a design.

=end

module Newsletter
  class Piece < ActiveRecord::Base
    set_table_name "#{Conf.newsletter_table_prefix}pieces"
    belongs_to :newsletter, :class_name => 'Newsletter::Newsletter'
    belongs_to :area, :class_name => 'Newsletter::Area'
    belongs_to :element, :class_name => 'Newsletter::Element'
    has_many :fields, :through => :element, :class_name => 'Newsletter::Field'
    has_many :field_values, :class_name => 'Newsletter::FieldValue'
    has_many :assets, :dependent => :destroy, :class_name => 'Newsletter::Asset'
  
    acts_as_list :scope => :newsletter, :column => :sequence
  
    named_scope :by_area, lambda {|area| {:conditions => {:area_id => area.id, :deleted_at => nil}}}
    named_scope :by_newsletter, lambda {|newsletter| {:conditions => {:newsletter_id => newsletter.id, :deleted_at => nil}}}
    
    # returns locals to be used in its Newsletter::Element design
    def locals
      values = Hash.new
      fields.each do |field|
        values[field.name.to_sym] = field.value_for_piece(self)
      end
      values
    end
    
    # used to save out a piece's fields, since they are inline in a piece's form  
    def field_values=(values)
      values.each_pair do |field_id,key_value_pairs|
        field = Field.find(field_id)
        field.set_value_for_piece(self,key_value_pairs)
      end
    end
  end
end