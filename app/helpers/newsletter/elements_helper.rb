module Newsletter
  module ElementsHelper
    def add_newsletter_field_link(name)
      link_to_function name, :class => "button" do |page|
        page.insert_html :bottom, :newsletter_fields, :partial => 'newsletter_field', 
          :object => Field.new
      end  
    end
  end
end