=begin rdoc
Aduthor::    Chris Hauboldt (mailto:biz@lnstar.com)
Copyright:: 2009 Lone Star Internet Inc.

NewsletterPieces are the glue that tie data together to form a piece in an area of a design.

=end

module Newsletter
  class Piece < ActiveRecord::Base
    self.table_name =  "#{::Newsletter.table_prefix}pieces"
    belongs_to :newsletter, :class_name => 'Newsletter::Newsletter'
    belongs_to :area, :class_name => 'Newsletter::Area'
    belongs_to :element, :class_name => 'Newsletter::Element'
    # has_many :fields, :through => :element, :class_name => 'Newsletter::Field'
    has_many :field_values, :class_name => 'Newsletter::FieldValue'
    has_many :assets, :dependent => :destroy, :class_name => 'Newsletter::Asset'
  
    acts_as_list :scope => :newsletter, :column => :sequence
  
    scope :active, where(:deleted_at => nil)
    scope :by_area, lambda {|area| {:conditions => {:area_id => area.id, :deleted_at => nil}}}
    scope :by_newsletter, lambda {|newsletter| {:conditions => {:newsletter_id => newsletter.id, :deleted_at => nil}}}

    attr_accessor :field_values_attributes

    #attr_accessible :field_values_attributes, :newsletter_id, :element_id, :area_id
    attr_protected :id

    #validates_presence_of :newsletter, :element, :area, :field_values
    
    # returns locals to be used in its Newsletter::Element design
    def locals
      return @locals if @locals.present?
      @locals = Hash.new
      fields.each do |field|
        @locals[field.name.to_sym] = field.value_for_piece(self)
      end
      @locals
    end

    # returns a pieces fields
    def fields
      element.try(:fields).try(:uniq) || []
    end

    # used to save out a piece's fields, since they are inline in a piece's form  
    def field_values_attributes=(values)
      @field_values_attributes = values
    end

    # whether it can respond to a 'method' in its locals hash
    def respond_to?(my_method,use_private=false)
      return true if super
      if locals.keys.include?(my_method.to_sym)
        true
      else
        false
      end
    end

    # respond for its named methods for its element's template
    # these values will be in its locals hash
    def method_missing(*args)
      if args.length == 1 and locals.has_key?(args[0].to_sym)
        locals[args[0].to_sym]
      else
        super
      end
    end

    # :nodoc override save for transaction to set its field values
    def save(*args)
      transaction do 
        set_field_values
        super
      end
    end  

    protected

    # sets the piece's field values after a save
    def set_field_values
      return unless defined?(@field_values_attributes) && @field_values_attributes.present?
      @field_values_attributes.each_pair do |field_id,key_value_pairs|
        field = Field.find(field_id)
        field.set_value_for_piece(self,key_value_pairs)
      end
    end

  end
end
