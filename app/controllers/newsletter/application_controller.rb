require 'dynamic_form'
require 'nested_form'
class Newsletter::ApplicationController < ActionController::Base
  layout 'newsletter/application'
  helper_method :title, :use_show_for_resources?, :site_url, :show_title?
  
  def title(value=nil)
    @title = value if value.present?
    @title
  end

  def show_title?
    true
  end

  def use_show_for_resources?
    ::Newsletter.use_show_for_resources
  rescue 
    false
  end

  def site_url
    ::Newsletter.site_url
  rescue
    "#{default_url_options[:protocol]||'http'}://#{default_url_options[:domain]}"
  end
end