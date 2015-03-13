require 'net/http'
require 'will_paginate'
require 'acts_as_list'
require 'dynamic_form'
require 'nested_form'
require 'carrierwave'
require 'carrierwave/orm/activerecord'
module Newsletter
  # namespace for newsletter tables in database i.e. newsletter_
  mattr_accessor :table_prefix
  # path where design text files are saved
  mattr_accessor :designs_path
  # the fully qualified url of site i.e. http://www.example.com
  mattr_accessor :site_url
  # the path to the site '/' if its at the root or /blarg if the rails app is at a subpath
  mattr_accessor :site_path
  # the default layout for the administration of newsletters
  mattr_accessor :layout
  # layout for the newsletter archive
  mattr_accessor :archive_layout
  # whether or not to redirect to the 'show' page of something after editing/creating or go to the 'index'
  mattr_accessor :use_show_for_resources
  # path to the newsletter assets (will be used for asset uploads)
  mattr_accessor :asset_path
  mattr_accessor :designs_require_authentication
  mattr_accessor :design_authorized_roles
  mattr_accessor :newsletters_require_authentication
  mattr_accessor :newsletter_authorized_roles
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

  def self.authorized?(user, object=nil)
    if object.eql?(::Newsletter::Design)
      if ::Newsletter.designs_require_authentication 
        if ::Newsletter.design_authorized_roles.present? 
          ::Newsletter.design_authorized_roles.include?(user.try(:role))
        else
          user.present?
        end
      else
        true
      end
    elsif object.eql?(::Newsletter::Newsletter)
      if ::Newsletter.newsletters_require_authentication 
        if ::Newsletter.newsletter_authorized_roles.present? 
          ::Newsletter.newsletter_authorized_roles.include?(user.try(:role))
        else
          user.present?
        end
      else
        true
      end
    else
      false
    end
  end
  
  def self.abilities
    <<-EOT
      if ::Newsletter.authorized?(user, ::Newsletter::Design)
        can :manage, [
          ::Newsletter::Design,
          ::Newsletter::Element,
          ::Newsletter::Area,
          ::Newsletter::Field
        ]
      end
      if ::Newsletter.authorized?(user, ::Newsletter::Newsletter)
        can :manage, [
          ::Newsletter::Newsletter,
          ::Newsletter::Piece,
          ::Newsletter::FieldValue
        ]
        can :read, [
          ::Newsletter::Design,
          ::Newsletter::Element,
          ::Newsletter::Area,
          ::Newsletter::Field
        ]
      end
      can :read, [
        ::Newsletter::Newsletter,
        ::Newsletter::Piece,
        ::Newsletter::FieldValue
      ]
    EOT
  end

  # an easy way to get the root of the gem's directory structure
  PLUGIN_ROOT = File.expand_path(File.join(File.dirname(__FILE__),'..','..'))
  # an easy way to get the root of the gem's assets
  def self.assets_path
    File.join(PLUGIN_ROOT,'assets')
  end
  # initializes the configuration options pulled from config/newsletter.yml and 
  # overrides with config/newsletter.local.yml if it exists
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
    ::Newsletter.designs_require_authentication ||= conf.designs_require_authentication || false rescue false
    ::Newsletter.newsletters_require_authentication ||= conf.newsletters_require_authentication || false rescue false
    ::Newsletter.design_authorized_roles ||= conf.design_authorized_roles || [] rescue []
    ::Newsletter.newsletter_authorized_roles ||= conf.newsletter_authorized_roles || [] rescue []
  end
end

# initializes mail_manager tie ins
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
