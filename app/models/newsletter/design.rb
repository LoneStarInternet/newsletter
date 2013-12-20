=begin rdoc
Author::    Chris Hauboldt (mailto:biz@lnstar.com)
Copyright:: 2009 Lone Star Internet Inc.

Newsletter::Designs define a main layout, with areas to group Elements/Pieces.


=end

module Newsletter
  class Design < ActiveRecord::Base
    self.table_name =  "#{Conf.newsletter_table_prefix}designs"
    has_many :areas, :order => :name, :class_name => 'Newsletter::Area'
    has_many :elements, :order => :name, :class_name => 'Newsletter::Element'
    belongs_to :updated_by, :class_name => 'User'
    after_create :write_design
  
    accepts_nested_attributes_for :areas

    attr_accessible :name, :description, :html_text, :areas_attributes

    scope :active, :conditions => {:deleted_at => nil}
  
    validates_presence_of :name

    # attr_protected :id
    #FIXME: make this work with deletable or convert to auditable, and extend it to access destroyed records
    #validates_uniqueness_of :name

    # Export a design's data to a YAML file. 
    def export(filename=nil)
      filename = "#{Conf.newsletters_path}/exports/#{name_as_path}-export.yaml" unless filename
      FileUtils.mkdir_p(File.dirname(filename))
      File.open(filename,'w') do |file|
        YAML.dump( {
          :name => name,
          :html_text => html_text,
          :description => description,
          :areas => areas.collect{|area| area.export_fields}, 
          :elements => elements.collect{|element| element.export_fields}
        },file)
      end
    end
  
    # Import a design from a YAML file, 
    # Parameters:
    #   filename - path/name of file on filesystem
    #   design_name => rename design if already taken
    def self.import(filename,design_name=nil)
      raise "You must give a filename to import!" unless filename
      data = YAML.load_file(filename)
      transaction do 
        data[:name] = design_name if design_name
        design = Design.create!(:name => data[:name], 
          :html_text => data[:html_text],
          :description => data[:description])
        data[:areas].each do |area_data|
          Area.import(design,area_data)
        end
        data[:elements].each do |element_data|
          Element.import(design,element_data)
        end
      end
    end

    # returns path to newsletter design for use in views and is the same for actual file
    def view_path(this_name=nil)
      "#{base_design_path(this_name)}/layout.html.erb"
    end
  
    # 
    def base_design_path(this_name=nil)
      "#{Conf.newsletters_path}/designs/#{name_as_path(this_name)}"
    end
  


    def html_text
      return @html_text if @html_text
      @html_text = read_design
    end
  
    def html_text=(text)
       @html_text = text
    end
  
    # def area_attributes=(area_attributes)
    #   area_attributes.each do |attributes|
    #     if attributes[:id].blank?
    #       Rails.logger.debug "Building Area : #{attributes.inspect}"
    #       areas.build(attributes)
    #     else
    #       Rails.logger.debug "Setting Area data: #{attributes.inspect}"
    #       area = areas.detect{|area| area.id == attributes[:id].to_i}
    #       area.attributes = attributes
    #     end
    #   end
    # end

  
    def name=(new_name)
      return if self[:name].eql?(new_name)
      @old_name = self[:name] unless @old_name
      self[:name] = new_name
    end
  
    def save(*args)
      transaction do 
        move_design_on_name_change
        write_design
        super
      end
    end  
  
    # returns a version of name that is nice for filesytem use
    def name_as_path(this_name=nil)
      this_name = name unless this_name
      this_name.gsub(/[^a-zA-Z0-9-]/,'_')
    end
  
    include Deleteable
    protected
    def read_design
      File.readlines(view_path).join
    rescue => e
      #flash[:warning] << "Couldn't open design for element '#{name}' which should exist at: #{file_path} #{e.message}"
      ""
    end

    def write_all_designs
      areas.collect{|area| area.elements}.flatten.uniq.each{|element| element.send(:write_design)}
      write_design
    end
  
    def move_design_on_name_change
      return unless @old_name and File.exists?(view_path(@old_name))
      FileUtils.mv(base_design_path(@old_name),base_design_path)
    end

    def write_design
      FileUtils.mkdir_p(File.dirname(view_path)) unless File.exists?(File.dirname(view_path))
      File.open(view_path,File::WRONLY|File::TRUNC|File::CREAT) do |file|
        file.write html_text
      end
    end
  
  
    # def save_areas
    #   areas.each do |area|
    #     if area.should_destroy?
    #       Rails.logger.debug "Destroying newsletter area: #{area.inspect}"
    #       area.destroy
    #     else
    #       Rails.logger.debug "Saving newsletter area: #{area.inspect}"
    #       area.save
    #     end
    #   end
    # end
  end
end