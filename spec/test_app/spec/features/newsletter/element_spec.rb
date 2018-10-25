require 'rails_helper'

RSpec.describe 'Element management', type: :feature do
  before(:each) do
    @design = import_design
    @newsletter = FactoryGirl.create(:newsletter, design: @design)
  end

  it "creates an element with valid attributes", js: true do
    #visit newsletter.edit_design_path(@design)
    ['Text','Textarea','Inlineasset'].each do |type|
      visit "/newsletter/designs/#{@design.id}/edit"
      click_link "Manage Elements", match: :first
      click_link "New Newsletter Element", match: :first
      fill_in "Name", with: "Bobo's #{type} Element"
      fill_in "HTML code", with: "<%= bobo_text %>"
      click_link "Add Field"
      within(:css, ".fields") do
        fill_in "Name", with: "bobo_text"
        fill_in "Label", with: "Bobo Text"
        select type, from: "Type"
      end
      check @design.areas.first.name
      click_button "Submit"
      Debugging::wait_until_success do
        @design.reload
        element = @design.elements.detect{|e| e.name.eql?("Bobo's #{type} Element")}
        expect(element.html_text).to eq("<%= bobo_text %>")
        expect(element.fields.length).to eq(1)
        expect(element.areas.length).to eq(1)
        text_field = element.fields.first
        expect(text_field.name).to eq 'bobo_text'
        expect(text_field.label).to eq 'Bobo Text'
      end
    end
  end

  it "removes a field from an element", js: true do
    visit "/newsletter/designs/#{@design.id}/edit"
    Debugging::wait_until_success do
      click_link "Manage Elements", match: :first
    end
    element = @design.elements.first
    Debugging::wait_until_success do
      within(:css, "#element_#{element.id}") do
        click_link "Edit"
      end
    end
    field = element.fields.first
    field_id = "field_#{field.type.split(/:+/).last.downcase}_#{field.id}"
    find(:css, "##{field_id} a").click() # click Remove for the field
    click_button "Submit"
    Debugging::wait_until_success do
      Newsletter::Field.deleted.find_by_id(field.id).present?
      Newsletter::Field.find_by_id(field.id).blank?
    end
  end

  it "has javascript on the editor" do
    visit "/newsletters/#{@newsletter.id}/editor" 
    expect(page.body).to include('<script')
  end

  it "has javascript available in public" do
    visit "/newsletters/#{@newsletter.id}/editor" 
    expect(page.body).to include('<script')
  end
  
  it "does not have javascript available in email" do
    visit "/newsletters/#{@newsletter.id}/email" 
    expect(page.body).not_to include('<script')
  end
  
end
