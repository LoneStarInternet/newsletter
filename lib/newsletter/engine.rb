require 'net/http'
require 'will_paginate'
require 'acts_as_list'
require 'dynamic_form'
require 'nested_form'
require 'carrierwave'
require 'carrierwave/orm/activerecord'
module Newsletter
  mattr_accessor :table_prefix, :designs_path, :site_url,
   :site_path, :layout, :archive_layout, :use_show_for_resources, :asset_path
  class Engine < ::Rails::Engine
    isolate_namespace Newsletter
    initializer "Newsletter.config" do |app|
      if File.exist?(File.join(Rails.root,'config','newsletter.yml'))
        Rails.logger.info "Initializing Newsletter"
        require 'newsletter/settings'
        ::Newsletter.initialize_with_config(::Newsletter::Settings.initialize!)
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
    ::Newsletter.table_prefix ||= conf.table_prefix || 'newsletter_' rescue 'newsletter_'
    ::Newsletter.designs_path ||= conf.designs_path || "#{Rails.root}/designs" rescue "#{Rails.root}/designs"
    default_url_options = ActionController::Base.default_url_options
    default_site_url = "#{default_url_options[:protocol]||'http'}://#{default_url_options[:domain]}" 
    ::Newsletter.site_url ||= conf.site_url || default_site_url rescue default_site_url
    ::Newsletter.site_path ||= conf.site_path || '/' rescue '/'
    ::Newsletter.layout ||= conf.layout || 'application' rescue 'application'
    ::Newsletter.archive_layout ||= conf.archive_layout || 'application' rescue 'application'    
    ::Newsletter.use_show_for_resources ||= conf.use_show_for_resources || false rescue false
    ::Newsletter.asset_path ||= conf.asset_path || 'newsletter_assets' rescue 'newsletter_assets'
  end
end
Newsletter::Engine.config.to_prepare do
  Rails.logger.info "Newsletter: Checking for Mail Manager plugin support"
  begin
    require 'mail_manager'
    require 'mail_manager/mailable_registry' unless defined? MailManager::MailableRegistry.respond_to?(:register)
    if (MailManager::MailableRegistry.respond_to?(:register) rescue false)
      MailManager::MailableRegistry.register('Newsletter::Newsletter',{
        :find_mailables => :active,
        :name => :name,
        :parts => [
          ['text/plain', :email_text],
          ['text/html', :email_html]
        ]
      })
      Newsletter::Newsletter.send(:include, MailManager::MailableRegistry::Mailable)
      Rails.logger.info "Registered Newsletter Mailable"
    else
      Rails.logger.info "Couldn't register Newsletter Mailable"
    end
  rescue LoadError => e; end
end
