require 'erb'
require 'yaml'

class Newsletter::Settings
  attr_reader :sections, :params
  
  def initialize(file = nil)
    @sections = {}
    @params = {}
    use_file!(file) if file
  end
  
  def use_file!(file)
    begin
      hash = YAML::load(ERB.new(IO.read(file)).result)       
      @sections.merge!(hash) {|key, old_val, new_val| (old_val || new_val).merge new_val }
      @params.merge!(@sections['common'])
    rescue => e
      nil
    end    
  end
  
  def use_section!(section)
    @params.merge!(@sections[section.to_s]) if @sections.key?(section.to_s)
  end
  
  def method_missing(param)
    param = param.to_s
    if @params.key?(param)
      @params[param]
    else
      Rails.logger.warn "Invalid AppConfig Parameter " + param
      nil
    end
  end

  def self.initialize!
    standard_file = File.join(Rails.root,'config','newsletter.yml')
    local_file = File.join(Rails.root,'config','newsletter.local.yml')
    unless File.exists?(standard_file)
      $stderr.puts "Missing Configuration: either define ::Conf with proper values or create a config/newsletter.yml with rake newsletter:default_app_config"
    end
    c = ::Newsletter::Settings.new
    c.use_file!(standard_file)
    c.use_file!(local_file)
    c.use_section!(Rails.env)
    c
  end
  
end
