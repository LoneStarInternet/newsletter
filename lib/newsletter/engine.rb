module Newsletter
  mattr_accessor :table_prefix, :designs_path, :site_url,
   :site_path, :layout, :use_show_for_resources, :asset_path
  class Engine < ::Rails::Engine
    isolate_namespace Newsletter
    initializer "MailManager.config" do |app|
      if File.exist?(File.join(Rails.root,'config','mail_manager.yml'))
        require 'mail_manager/config'
        MailManager.initialize_with_config(MailManager::Config.initialize!)
      end
      config.generators do |g|
        g.test_framework :rspec, :fixture => false
        g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      end
    end
  end
  PLUGIN_ROOT = File.expand_path(File.join(File.dirname(__FILE__),'..','..'))
  def self.assets_path
    File.join(PLUGIN_ROOT,'assets')
  end
  def self.initialize_with_config(conf)
    Newsletter.table_prefix ||= conf.table_prefix || 'newsletter_' rescue 'newsletter_'
    Newsletter.designs_path ||= conf.designs_path || "#{Rails.root}/designs" rescue "#{Rails.root}/designs"
    default_url_options = ActionController::Base.default_url_options
    default_site_url = "#{default_url_options[:protocol]||'http'}://#{default_url_options[:domain]}" 
    Newsletter.site_url ||= conf.site_url || default_site_url rescue default_site_url
    Newsletter.site_path ||= conf.site_path || '/' rescue '/'
    Newsletter.layout ||= conf.layout || 'application' rescue 'application'
    Newsletter.use_show_for_resources ||= conf.use_show_for_resources || false rescue false
    Newsletter.asset_path ||= conf.asset_path || 'newsletter_assets' rescue 'newsletter_assets'
  end
end

begin
  require 'mail_manager/mailable_registry' unless defined? MailManager::MailableRegistry.respond_to?(:register)
  if defined? MailManager::MailableRegistry.respond_to?(:register)
    MailManager::MailableRegistry.register('Newsletter::Newsletter',{
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
rescue LoadError => e; end