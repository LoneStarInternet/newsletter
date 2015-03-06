require 'spec_helper'

feature 'Element management' do
  before(:each) do
    @design = import_design
  end

  scenario "creates an element with valid attributes", js: true do
    #visit edit_design_path(@design)
    visit "/newsletter/designs/#{@design.id}/edit"
    click_link "Manage Elements"
    click_link "New Newsletter Element"
    fill_in "Name", with: "Bobo's First Element"
    fill_in "Html text", with: "<%= bobo_text %>"
    click_link "Add Field"
    within(:css, ".fields") do
      fill_in "Name", with: "bobo_text"
      fill_in "Label", with: "Bobo Text"
    end
    check @design.areas.first.name
    click_button "Submit"
    Debugging::wait_until_success do
      @design.reload
      element = @design.elements.detect{|e| e.name.eql?("Bobo's First Element")}
      expect(element.html_text).to eq("<%= bobo_text %>")
      expect(element.fields.length).to eq(1)
      expect(element.areas.length).to eq(1)
      #field = element.fields.first
    end
  end

end
