module Newsletter
  module LayoutHelper
    def title(value=nil, locals={})
      if value.nil?
        @page_title
      else
        @page_title = translate( value, locals)
        "<h1>#{@page_title}</h1>".html_safe
      end
    end

    def use_show_for_resources?
      ::Newsletter.use_show_for_resources
    rescue 
      # :nocov: shouldn't happen
      false
      # :nocov:
    end

    def show_title?
      return @show_title if defined? @show_title
      true
    rescue 
      # :nocov: shouldn't happen
      false
      # :nocov:
    end

    def site_url
      ::Newsletter.site_url
    rescue
      # :nocov: shouldn't happen
      "#{default_url_options[:protocol]||'http'}://#{default_url_options[:domain]}"
      # :nocov:
    end

    def translate(key, options={})
      super(key, options.merge(raise: true))
    rescue I18n::MissingTranslationData
      key
    end
  end
end
