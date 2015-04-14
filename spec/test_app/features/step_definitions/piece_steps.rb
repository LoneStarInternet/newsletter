When(/^I select to add a "(.*?)" from the "(.*?)" area$/) do |element_name, area_name|
  area = Newsletter::Area.where(name: area_name.downcase.gsub(/ /,'_')).first 
  within(:css,"#add_element_for_area_#{area.id}") do
    step %Q|I select "#{element_name}" from "Area: #{area.name.humanize}"|
  end
end

When(/^I press the "(.*?)" area's "(.*?)" button$/) do |area_name, add_element|
  area = Newsletter::Area.where(name: area_name.downcase.gsub(/ /,'_')).first 
  within(:css,"#add_element_for_area_#{area.id}") do
    step %Q|I press "Add Element"|
  end
end

Then(/^a "(.*?)" should exist in "(.*?)"'s "(.*?)" are with an? "(.*)" ([^"]+) of "(.*?)"$/) do |element_name, newsletter_name, area_name, field_name, method, value|
  newsletter = Newsletter::Newsletter.where(name: newsletter_name).last
  area = newsletter.areas.detect{|a| a.name.eql?(underscore(area_name))}
  element = area.elements.detect{|e| e.name.eql?(element_name)}
  expect(newsletter.pieces.detect{|piece|
    piece.area == area && piece.element == element &&
    piece.locals[field_name.to_sym].send(method) == value
  }).not_to be nil
end



