=begin rdoc
Author::    Chris Hauboldt (mailto:biz@lnstar.com)
Copyright:: 2009 Lone Star Internet Inc.

Areas define what elements can exist in a part of a newleter design. Also used to group and order actual Pieces in a filled in Newsletter.

=end

module Newsletter
  class Area < ActiveRecord::Base
    self.table_name =  "#{::Newsletter.table_prefix}areas"
    belongs_to :design, :class_name => 'Newsletter::Design'
    has_and_belongs_to_many :elements, :order => 'name', :join_table => 
      "#{::Newsletter.table_prefix}areas_#{::Newsletter.table_prefix}elements",
      :class_name => 'Newsletter::Element'
    has_many  :pieces, :order => 'sequence', :class_name => "Newsletter::Piece"
    belongs_to :updated_by, :class_name => 'User'
  
    attr_accessor :_destroy

    attr_protected :id
  
    validates_presence_of :name
    #FIXME: make this work with deletable or convert to auditable, and extend it to access destroyed records
    #validates_uniqueness_of :name, :scope => :design_id
  
    scope :active, :conditions => {:deleted_at => nil}
    scope :by_name, lambda {|name| {:conditions => {:name => name}}}
  
    include Deleteable
  
    # returns field data so that Newsletter::Design.export(instance) can export itself to a YAML file
    def export_fields
      { :name => name,
        :description => description 
      }
    end

    # builds areas from data pulled out of an exported YAML file by Newsletter::Design.import(class)
    def self.import(design,data)
      area = Area.create(:name => data[:name], :description => data[:description])
      area.design = design
      area.save
    end
  
  end
end
