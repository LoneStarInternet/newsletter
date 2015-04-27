module Newsletter
  module NewslettersHelper
    def is_email?
      params[:mode].eql?('email')
    end

    def filter(text)
      new_text = filter_eols_to_brs(text,text)
      new_text = filter_email_addresses_to_mailtos(new_text,text)
      new_text = filter_urls_to_links(new_text,text)
      new_text.html_safe
    end

    def design_image(image_filename, options={})
      options_text = ''
      options.each_pair do |key,value|
        options_text << %Q| #{key}="#{ERB::Util.html_escape value}"|
      end
      %Q|<img src="#{ERB::Util.html_escape ::Newsletter.site_url + 
        @newsletter.image_uri(image_filename)
        }"#{options_text}/>|.html_safe
    end

    protected 
    def filter_eols_to_brs(text,orig_text)
      return '' if text.blank?
      return text if orig_text =~ /<br\s*\/>/i
      text.gsub(/(\r\n|\r|\n)/,'<br/>')
    end

    def filter_email_addresses_to_mailtos(text,orig_text)
      return '' if text.blank?
      return text if orig_text =~ /<a\s+href/i
   text.gsub(/([a-z0-9!#\$%&'*+\/=?^_`{|}~-]+(?:\.[a-z0-9!#\$%&'*+\/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+(?:[A-Z]{2}|com|org|net|gov|mil|biz|info|mobi|name|aero|jobs|museum)\b)/mi,%Q|<a href="mailto:\\1" target="_blank">\\1</a>|)
    end

    def filter_urls_to_links(text,orig_text)
      return '' if text.blank?
      return text if orig_text =~ /<a\s+href/i
text.gsub(/(\b(?:(?:https?|ftp|file):\/\/|www\.|ftp\.)(?:\([-A-Z0-9+&@#\/%=~_|$?!:,.]*\)|[-A-Z0-9+&@#\/%=~_|$?!:,.])*(?:\([-A-Z0-9+&@#\/%=~_|$?!:,.]*\)|[A-Z0-9+&@#\/%=~_|$]))/mi) do |match|
        if match.to_s.include?('://') 
           %Q|<a href="#{match}" target="_blank">#{match}</a>|
        else
           %Q|<a href="http://#{match}" target="_blank">#{match}</a>|
        end
      end
    end
  end
end
