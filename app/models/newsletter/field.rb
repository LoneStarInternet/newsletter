=begin rdoc
Author::    Chris Hauboldt (mailto:biz@lnstar.com)
Copyright:: 2009 Lone Star Internet Inc.

Defines the data behaviour of a Newsletter::Piece's fields. Tied to Newsletter::Pieces through Newsletter::Elements.

This is a base object and is never directly used, but is used to define different fields through Single Table Inheritance.

=end

module Newsletter
    class Field < ActiveRecord::Base
      self.table_name =  "#{::Newsletter.table_prefix}fields"
      belongs_to :element, :class_name => 'Newsletter::Element'
      has_many :field_values, :class_name => 'Newsletter::FieldValue'
      belongs_to :updated_by, :class_name => 'User'

      attr_accessor :_destroy

      acts_as_list :scope => :element, :column => :sequence

      validates_presence_of :name
=begin
      FIXME: make this work with deletable or convert to auditable, and extend it to access destroyed records
      validates_uniqueness_of :name, :scope => [:element_id], :unless => Proc.new { |field|
        field.new_record? ? Field.find(:first,:conditions =>
        ["name=? and element_id=? and deleted_at is null", field.element_id]).nil? :
        Field.find(:first,:conditions =>
        ["name=? and element_id=? and id!=? and deleted_at is null", field.element_id,
        field.id]).nil? }
=end
      attr_accessible :name, :type, :element_id, :label, :sequence, :is_required, 
        :description, :updated_by, :_destroy
      
      include Deleteable

      # returns field data so that Newsletter::Design.export(instance) can export itself to a YAML file  
      def export_fields
        { 
          :name => name,
          :label => label,
          :sequence => sequence,
          :is_required => is_required,
          :description => description,
          :type => self[:type],
        }
      end

      # returns field data so that Newsletter::Design.export(instance) can export itself to a YAML file
      def self.import(element,data)
        return unless data[:type]
        field = data[:type].constantize.new(
          :name => data[:name],
          :label => data[:label],
          :sequence => data[:sequence],
          :is_required => data[:is_required],
          :description => data[:description]
        )
        field.element = element
        field.save
      end

      # returns a pieces value for a given Newsletter::Field
      def value_for_piece(piece,safe=true)
        return get_value(piece).to_s.html_safe if safe
        get_value(piece).to_s
      end

      # sets a pieces value for a Newsletter::Field
      def set_value_for_piece(piece,params)
        params.each_pair do |key,value|
          set_value(piece,key,value)
        end
      end

      def set_value(piece,key,value)
        field_value = field_values.by_piece(piece).by_key(key).first
        if field_value
          field_value.update_attribute(:value,value)
        else
          field_value = piece.field_values.build(:key => key,:value => value)
          field_value.field_id = self.id 
        end
      end

      def get_value(piece,key=nil)
        return field_values.by_piece(piece).by_key(key).first.try(:value) if key  
        field_values.by_piece(piece).first.try(:value)
      end

      # morph into a different Newsletter::Field type(if a user changes the type of a field)
      def self.morph(field,type)
        return field if field.class.name.eql?(type.to_s)
        return type.constantize.new(field.attributes) if field.new_record?
        field.update_attribute('type',type)
        Field.find(field.id)
      end

      # find the partial to display a form for creating a Newsletter::Piece
      def form_partial_path
         "newsletter/fields/#{type.to_s.gsub(/.*Newsletter::Field::/,'').gsub(/([^A-Z])([A-Z])/,'\\1_\\2').downcase}"
      end

      # helper for selecting type of field to use when creating/editing a Newsletter::Field.
      def self.valid_types
        @valid_types = ['Newsletter::Field::Text','Newsletter::Field::TextArea','Newsletter::Field::InlineAsset']
      end
    end
end

