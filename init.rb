unless defined? Deletable.respond_to?(:object_id)
  require 'deletable'
end

# Include hook code here
if defined? MailMgr::MailableRegistry.respond_to?(:register)
  MailMgr::MailableRegistry.register('Newsletter::Newsletter',{
    :find_mailables => :active,
    :name => :name,
    :parts => [
      ['text/plain', :email_text],
      ['text/html', :email_html]
    ]
  })
  Rails.logger.warn "Registered Newsletter Mailable"
else
  Rails.logger.warn "Couldn't register Newsletter Mailable"
end

module ::NewsletterPlugin
  PLUGIN_ROOT = File.dirname(__FILE__)
  def self.load_routes(map)
    begin
      path_prefix = "#{Conf.site_path}#{Conf.newsletter_path_prefix}"
    rescue => e
      path_prefix = '/admin/newsletter'
    end

    map.newsletter_archive "/newsletters/archive", :controller => 'newsletter/newsletters',
      :action => 'archive', :method => :get
    map.public_newsletter_mode "/newsletters/:id/:mode", :controller => 'newsletter/newsletters', 
      :action => 'show', :method => :get
    map.public_newsletter "/newsletters/:id/public", :controller => 'newsletter/newsletters', 
      :action => 'show', :method => :get
    map.public_newsletter "/newsletters/:id", :controller => 'newsletter/newsletters', 
      :action => 'show', :method => :get

    map.namespace(:newsletter) do |news|
      news.resources :newsletters, :path_prefix => path_prefix,
        :member => { :unpublish => :get, :publish => :get },
        :collection => { :sort => :get }do |newsletter|
        newsletter.resources :pieces, :only => [:index,:new,:create]
      end

      news.resources :pieces, :only => [:edit,:create,:update,:destroy], :path_prefix => path_prefix

      news.resources :designs, :path_prefix => path_prefix do |design|
         design.resources :elements, :only => [:index,:new,:create]
      end
    
      news.resources :elements, :only => [:edit,:create,:update,:destroy], :path_prefix => path_prefix
    end
    map.sort_newsletter_newsletter_area "#{path_prefix}/newsletters/:newsletter_id/areas/:id/sort", 
      :controller=> 'newsletter/areas', :action => 'sort', :method => :get
  end
end
