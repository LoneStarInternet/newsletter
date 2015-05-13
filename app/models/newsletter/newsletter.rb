=begin rdoc
Author::    Chris Hauboldt (mailto:biz@lnstar.com)
Copyright:: 2009 Lone Star Internet Inc.

Newsletter ties user-added data to a Newsletter::Design through Newsletter::Pieces. 

Newsletter also registers itself to be Mailable through the List Manager of Mailing if the plugin exists. (MLM isn't a nice term apparently) It is also the starting point for rendering a newsletter for both the web archive and when being sent as a mailable. A newsletter will show up on an archives page and be available to send in an email after it is "Published". Newsletters may also be Un-Published.

=end

module Newsletter
  class Newsletter < ActiveRecord::Base
    Rails.logger.info "Loading Newsletter Object"
    self.table_name =  "#{::Newsletter.table_prefix}newsletters"
    belongs_to :design, :class_name => 'Newsletter::Design'
    has_many :pieces, :order => 'sequence', :class_name => 'Newsletter::Piece', 
      :conditions => "#{::Newsletter.table_prefix}pieces.deleted_at is null"
  
    scope :published, {:conditions => "#{::Newsletter.table_prefix}newsletters.published_at is not null", 
      :order => "#{::Newsletter.table_prefix}newsletters.created_at desc"}
    scope :active, {:conditions => "#{::Newsletter.table_prefix}newsletters.deleted_at is null", 
      :order => "#{::Newsletter.table_prefix}newsletters.created_at desc"}
  
    validates_presence_of :name
  
    acts_as_list :column => :sequence

    attr_protected :id

    # returns any piece that is a headline
    def headlines
      pieces.select{|piece| piece.respond_to?(:headline)}
    end
    
    # returns it's stylesheet
    def stylesheet 
      design.stylesheet_text.to_s
    end

    # returns the newsletter's content as plain text
    def email_text
      "Get the new Newsletter from here: " + public_url + "\n" +
      '-'*30 + "\n\n" + generate_plain_text('email')
    end

    # returns the newsletter's content as html text with unsubscribe data(this should be encapsulated in an 
    #   "if is_email" block in your design)
    def email_html
      generate('email')
    end
  
    # Currently using lynx to generate newsletter as text
    def generate_plain_text(mode='')
      IO.popen('lynx -stdin --dump','w+') do |lynx|
        lynx.write generate(mode)
        lynx.close_write
        lynx.readlines.join
      end
    end

    # whether or not the newsletter will show on the archives page
    def published?
      !published_at.nil?
    end

    # sets published_at to current time, so it will be shown in the archives page
    def publish
      update_attribute(:published_at, Time.now)
    end
  
    # clears published_at so that it is removed from the archives page
    def unpublish
      update_attribute(:published_at, nil)
    end

    # generates a public url for the newsletter
    def public_url(mode='')
      "#{::Newsletter.site_url}/newsletters/#{self[:id]}#{mode.blank? ? '' : "/#{mode}"}"
    end

    def image_uri(filename)
      File.join(design.images_path.gsub(/.*public\//,'/'), filename)
    end
  
    # used to generate the newsletter from a model or someplace other than the web stack
    #   FIXME: There has to be a better way, where railsy stuff works ... erb doesn't seem 
    #          to be enough, so we're just using the web app
    # Parameters:
    #   mode: if set to 'email', is_email? will be true as a helper in the designs, for 
    #         useage to not include javascript, show/hide subscription links, etc.
    #   substitutions: data to substitute out of the content such as "UNSUBSCRIBE_URL"
    def generate(mode='')
      fetch(public_url(mode))
    end

    # retrieve a newsletter area by name - for use in render/views
    def area(name)
      design.areas.by_name(name).first
    end
  
    # retrieve a list of locals to send to the main layout of the newsletter design view
    # this is so that we can just "<%= area %>" without putting anything fancy in the view
    def locals
      variables = Hash.new
      design.areas.each do |area|
        variables[area.name.to_sym] = area
      end
      variables[:title] = self.name
      variables
    end
  
    # :nodoc sets a pieces attributes coming from the form
    # FIXME: this is probably covered by rails 3 accepts_attributes_for, but we 
    # will change when we go to 4 anyways
    def piece_attributes=(piece_attributes)
      piece_attributes.each do |attributes|
        pieces.build(attributes)
      end
    end
  
    # helper to get areas for newsletter
    def areas
      design.try(:areas).to_a
    end
    
    # fetch a url and return the body
    def fetch(uri_str, limit = 10)
      uri = URI.parse(uri_str)
      if uri.scheme.eql?('file')
        File.binread(uri_str.gsub(%r#^file://#,''))
      else
        uri.read
      end
    end

  end
end
