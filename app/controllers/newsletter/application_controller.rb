require 'dynamic_form'
require 'nested_form'
require 'cancan'
class Newsletter::ApplicationController < ApplicationController 
  layout Newsletter.layout
  helper_method :title, :use_show_for_resources?, :site_url
  load_and_authorize_resource

  def title(value=nil)
    if value.nil?
      @page_title
    else
      @page_title = value
      "<h1>#{@page_title}</h1>".html_safe
    end
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
