=begin rdoc
Author::    Chris Hauboldt (mailto:biz@lnstar.com)
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

    attr_protected :id
    
    # returns locals to be used in its Newsletter::Element design
    def locals
      return @locals if @locals.present?
      @locals = Hash.new
      fields.each do |field|
        @locals[field.name.to_sym] = field.value_for_piece(self)
        define_getter_for_locals(field.name.to_sym) unless respond_to?(field.name.to_sym)
      end
      @locals
    end

    def fields
      element.try(:fields).try(:uniq) || []
    end

    def newsletter
      return nil unless newsletter_id.present?
      @newsletter ||= ::Newsletter::Newsletter.find(newsletter_id)
    end
    
    # used to save out a piece's fields, since they are inline in a piece's form  
    def field_values_attributes=(values)
      @field_values_attributes = values
    end

    def set_field_values
      return unless defined?(@field_values_attributes) && @field_values_attributes.present?
      @field_values_attributes.each_pair do |field_id,key_value_pairs|
        field = Field.find(field_id)
        field.set_value_for_piece(self,key_value_pairs)
      end
    end

    def respond_to?(my_method,use_private=false)
      return true if super
      if locals.keys.include?(my_method.to_sym)
        define_getter_for_locals(my_method)
        true
      else
        false
      end
    end

    def method_missing(*args)
      if args.length == 1 and locals.has_key?(args[0].to_sym)
        define_getter_for_locals(args[0])
      else
        super
      end
    end

    def save(*args)
      transaction do 
        set_field_values
        super
      end
    end  

    private
    def define_getter_for_locals(key)
      class_eval %Q|
      def #{key}
        locals[:#{key}]
      end|
      eval key.to_s
    end
  end
end
