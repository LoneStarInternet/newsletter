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
  # the path to the site '/' if its at the root or /blarg if the rails engine is at a subpath defaults to '/admin'
  mattr_accessor :site_path
  # the default layout for the administration of newsletters
  mattr_accessor :layout
  # layout for the newsletter archive
  mattr_accessor :archive_layout
  # path to the newsletter assets (will be used for asset uploads)
  mattr_accessor :asset_path
  # designs_require_authentication: whether you need to log in to manage designs(recommended)
  mattr_accessor :designs_require_authentication
  # design_authorized_roles: array of role names that can manage designs
  mattr_accessor :design_authorized_roles
  # newsletters_require_authentication: whether you need to log in to manage newsletters(everyone can currently see them.. devise your own abilities if you want to require login for these)
  mattr_accessor :newsletters_require_authentication
  # newsletter_authorized_roles: array of role names that can manage newsletters
  mattr_accessor :newsletter_authorized_roles
  # roles_method: the method which gives a list of role names for the 'current_user' of the app, if it answers with an array of names as strings with 'roles' or a string with 'role' this doesn't have to be set
  mattr_accessor :roles_method

  # the following 2 will probably be deprecated soon
  # whether or not to redirect to the 'show' page of something after editing/creating or go to the 'index'
  mattr_accessor :use_show_for_resources
  # provides a view helper for whether to show a title in a layout/template
  mattr_accessor :show_title
  class Engine < ::Rails::Engine
    isolate_namespace Newsletter
    initializer "Newsletter.config" do |app|
      if File.exist?(File.join(Rails.root,'config','newsletter.yml'))
        Rails.logger.info "Initializing Newsletter"
        require 'newsletter/settings'
        ::Newsletter.initialize_with_config(::Newsletter::Settings.initialize!)
      end
    end
    initializer "newsletter.factories", :after => "factory_girl.set_factory_paths" do
      FactoryGirl.definition_file_paths << File.expand_path('../../../spec/test_app/spec/factories', __FILE__) if defined?(FactoryGirl)
    end
    config.generators do |g|
      g.test_framework :rspec, :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
    end
  end

  def self.authorized_for_roles?(user,roles=[])
    user_roles = if ::Newsletter.roles_method.present?
      user.send(::Newsletter.roles_method)
    elsif user.respond_to?(:roles)
      user.roles
    elsif user.respond_to?(:role)
      [user.role]
    else
      []
    end
    user_roles = [user_roles] unless user_roles.is_a?(Array)
    roles.detect{|role| user_roles.map(&:to_sym).map(&:to_s).include?(role.to_s)}.present?
  end

  def self.authorized?(user, object=nil)
    if object.eql?(::Newsletter::Design)
      return true unless ::Newsletter.designs_require_authentication 
      return false if user.blank?
      return true unless ::Newsletter.design_authorized_roles.present? 
      authorized_for_roles?(user, ::Newsletter.design_authorized_roles)
    elsif object.eql?(::Newsletter::Newsletter)
      return true unless ::Newsletter.newsletters_require_authentication 
      return false if user.blank?
      return true unless ::Newsletter.newsletter_authorized_roles.present? 
      authorized_for_roles?(user, ::Newsletter.newsletter_authorized_roles)
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
        can [:sort,:publish,:unpublish], ::Newsletter::Newsletter
        can :sort, ::Newsletter::Area
      end
      can :read, [
        ::Newsletter::Newsletter,
        ::Newsletter::Piece,
        ::Newsletter::FieldValue
      ]
      can :archive, ::Newsletter::Newsletter
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
    if conf.params.has_key?('table_prefix')
      ::Newsletter.table_prefix ||= conf.table_prefix.to_s # allow empty
    else
      ::Newsletter.table_prefix ||= 'newsletter_'
    end
    ::Newsletter.designs_path ||= conf.designs_path || "#{Rails.root}/designs" rescue "#{Rails.root}/designs"
    default_url_options = ActionController::Base.default_url_options
    default_site_url = "#{default_url_options[:protocol]||'http'}://#{default_url_options[:domain]}" 
    ::Newsletter.site_url ||= conf.site_url || default_site_url rescue default_site_url
    ::Newsletter.site_path ||= conf.site_path || '/' rescue '/'
    ::Newsletter.layout ||= conf.layout || 'application' rescue 'application'
    ::Newsletter.archive_layout ||= conf.archive_layout || 'application' rescue 'application'    
    ::Newsletter.use_show_for_resources ||= conf.use_show_for_resources || false rescue false
    ::Newsletter.asset_path ||= conf.asset_path || 'newsletter_assets' rescue 'newsletter_assets'
    ::Newsletter.show_title ||= conf.show_title || true rescue true
    ::Newsletter.designs_require_authentication ||= conf.designs_require_authentication || false rescue false
    ::Newsletter.newsletters_require_authentication ||= conf.newsletters_require_authentication || false rescue false
    ::Newsletter.design_authorized_roles ||= conf.design_authorized_roles || [] rescue []
    ::Newsletter.newsletter_authorized_roles ||= conf.newsletter_authorized_roles || [] rescue []
    ::Newsletter.roles_method ||= conf.roles_method || '' rescue ''
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
