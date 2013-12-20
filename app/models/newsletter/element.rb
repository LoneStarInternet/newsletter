=begin rdoc
Author::    Chris Hauboldt (mailto:biz@lnstar.com)
Copyright:: 2009 Lone Star Internet Inc.

Newsletter::Elements define the way a Newsletter::Piece looks with an erb design and the data it can hold with Newsletter::Fields. They can exist in multiple Newsletter::Areas, but currently belong to only 1 design.

=end

module Newsletter
  class Element < ActiveRecord::Base
    set_table_name "#{Conf.newsletter_table_prefix}elements"
    has_and_belongs_to_many :areas, :class_name => 'Newsletter::Area',
      :join_table => "#{Conf.newsletter_table_prefix}areas_#{Conf.newsletter_table_prefix}elements"
    has_many :fields, :order => 'sequence', :class_name => 'Newsletter::Field'
    has_many :pieces, :class_name => 'Newsletter::Piece'
    belongs_to :design, :class_name => 'Newsletter::Design'
    belongs_to :updated_by, :class_name => 'User'
  
    scope :by_design, lambda{|design| {:conditions =>{:design_id => design.id}}}
  
    validates_presence_of :name

    accepts_nested_attributes_for :fields

    attr_protected :id
    #FIXME: make this work with deletable or convert to auditable, and extend it to access destroyed records
    #validates_uniqueness_of :name, :scope => :design_id
  
    # defines the design path for the element as used in a render :partial => (without '_')
    def view_path(this_name=nil)
        this_name = self[:name] unless this_name
          "#{Conf.newsletters_path}/designs/#{design.name.gsub(/[^a-zA-Z0-9-]/,'_')}/elements/#{name_as_path(this_name)}.html.erb"
    end
  
    # returns a version of name that is nice for filesytem use
    def name_as_path(this_name=nil)
      this_name = name unless this_name
      this_name.gsub(/[^a-zA-Z0-9-]/,'_').downcase
    end
  
    # defines where the file is in the filesystem
    def file_path(this_name=nil)
      File.dirname(view_path(this_name)) + '/_' + File.basename(view_path(this_name))
    end
  
    # used to record old name of an element such that the design can be moved to the new name
    def name=(new_name)
      return if self[:name].eql?(new_name)
      @old_name = self[:name] unless @old_name
      self[:name] = new_name
    end
  
    # retrieves the html erb design from the file system
    def html_text
      return @html_text if @html_text
      @html_text = read_design
    end

    # sets and saves the html erb design to update the file after a successful save
    def html_text=(text)
      @html_text = text
    end
  
    def update_attributes(params={})
      transaction do 
        super
      end
    end
  # {"0"=>{"name"=>"asdfas", "label"=>"asdfasd", "description"=>"fasdfasdf", 
  #   "type"=>"Newsletter::Field::TextArea", "_destroy"=>"false", "id"=>"22"},
  #    "1"=>{"name"=>"asdfasdf", "label"=>"asdfasdf", "description"=>"asdfasdf",
  #     "type"=>"Newsletter::Field::InlineAsset", "_destroy"=>"false", "id"=>"23"}}
  #   # # used to modify Newsletter::Fields in-form
    def fields_attributes=(fields_attributes)
      @fields_attributes = fields_attributes
    end

    def save_fields
      @fields_attributes.each_pair do |index,attributes|
        should_destroy = ['true','1'].include?attributes.delete(:_destroy)
        if attributes[:id].blank?
          next if should_destroy
          attributes.delete(:id)
          klass = attributes.delete(:type)
          fields << klass.constantize.new(attributes)
        else
          id = attributes.delete(:id).to_i
          if should_destroy
            fields.where(id: id).limit(1).each(&:destroy)
          else
            type = attributes.delete(:type)
            field = fields.detect{|field| field.id == id}
            field.update_attributes(attributes)
            field = Field.morph(field,type) unless field.class.name.eql?(type)
          end
        end
      end
    end
  
    # returns field data so that Newsletter::Design.export(instance) can export itself to a YAML file  
    def export_fields
      { :name => name,
        :description => description,
        :html_text => html_text,
        :areas => areas.collect{|area| area.export_fields},
        :fields => fields.collect{|field| field.export_fields}
      }
    end
  
    # builds areas from data pulled out of an exported YAML file by Newsletter::Design.import(class)  
    def self.import(design,data)
      element = Element.new(:name => data[:name], 
        :html_text => data[:html_text],
        :description => data[:description])
      element.design = design
      element.save
      data[:areas].each do |area_data|
        element.areas <<
          Area.find_all_by_design_id_and_name(design.id,area_data[:name])
      end
      data[:fields].each do |field_data|
          Field.import(element,field_data)
      end
    end
  
    def save(*args)
      transaction do 
        move_design_on_name_change
        write_design
        super
        save_fields
      end
    end
  
    include Deleteable
    protected
    def read_design
      File.readlines(file_path).join
    rescue => e
      #send back an empty string if no file exists yet for the design... don't raise an error
      ""
    end
  
    def write_design
      FileUtils.mkdir_p(File.dirname(file_path)) unless File.exists?(File.dirname(file_path))
      File.open(file_path,File::WRONLY|File::TRUNC|File::CREAT) do |file|
        file.write html_text
      end
    end
  
    def move_design_on_name_change
      return unless @old_name and File.exists?(file_path(@old_name))
      FileUtils.mv(file_path(@old_name),file_path)
    end
  
    # def save_fields
    #   Rails.logger.warn "Fields: #{fields.inspect}"
    #   fields.each do |field|
    #     if field.should_destroy?
    #       Rails.logger.warn "Destroy Field: #{field.inspect}"
    #       field.delete
    #     else
    #       Rails.logger.warn "Save Field: #{field.inspect}"
    #       field.save!      
    #     end
    #   end
    # end
  end
end