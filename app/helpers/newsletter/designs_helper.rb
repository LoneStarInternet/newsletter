module Newsletter
  module DesignsHelper
    #left 'newsletter' in function name for helper scoping
    def add_newsletter_area_link(name)
      link_to_function name, :class => "button" do |page|
        page.insert_html :bottom, :areas, :partial => 'newsletter_area', 
          :object => Area.new
      end  
    end
  end
end