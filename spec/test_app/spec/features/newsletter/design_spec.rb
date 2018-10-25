require 'rails_helper'

RSpec.feature Newsletter::Design do 
  let(:left_area_only_layout) {
    <<EOT
  <%= render left_area %>
EOT
  }
  let(:full_layout) {
    <<EOT
  <%= render left_area %>
  <%= render right_area %>
EOT
  }
  context "a new design" do
    it "can be created", js: true do
      visit "/newsletter/designs"
      click_link "New Design"
      fill_in "Name", with: "My Design"
      fill_in "Description", with: "This is an awesome design!"
      fill_in "HTML code", with: left_area_only_layout
      fill_in "Style Sheet", with: ".bobos { background-color: blue; }"
      click_link "Add Area"
      find(:css, ".area input").set 'left_area'
      click_button "Submit"
      @design = Newsletter::Design.where(name: 'My Design').first
      expect(Newsletter::Design.count).to eq 1
      expect(@design.description).to eq "This is an awesome design!"
      expect(remove_whitespace(@design.html_text)).to eq remove_whitespace(
        left_area_only_layout)
      expect(@design.areas.count).to eq 1
      @left_area = @design.areas.first
      expect(@left_area.name).to eq "left_area"
      and_it "can be edited" do
        click_link "Add Area"
        find(:css, "#new_area input").set 'right_area'
        fill_in "HTML code", with: full_layout
        click_button "Submit"
        @design = Newsletter::Design.first
        expect(Newsletter::Design.count).to eq 1
        expect(@design.areas.count).to eq 2
        @right_area = @design.areas.detect{|a| a.name.eql?('right_area')}
        @left_area = @design.areas.detect{|a| a.name.eql?('left_area')}
        expect(remove_whitespace(@design.html_text)).to eq remove_whitespace(full_layout)
        expect(@design.stylesheet_text).to eq ".bobos { background-color: blue; }"
      end
      and_it "when managing elements" do
        and_it "can create an element with a text area in the left area" do
          click_link "Manage Elements"
          click_link "New Newsletter Element"
          fill_in "Name", with: "Left Area Text"
          fill_in "Description", with: "Left Area Text description instructions"
          fill_in "HTML code", with: "<%= filter(my_paragraph) %>"
          click_link "Add Field"
          within(:css, "#new_field") do
            fill_in "Name", with: "my_paragraph"
            fill_in "Label", with: "My Paragraph"
            fill_in "Description", with: "My Paragraph is a text area for you!"
            select "Textarea", from: "Type"
          end
          check "left_area"
          click_button "Submit"
          expect(Newsletter::Element.count).to eq 1
          @left_area.reload
          expect(@left_area.elements.count).to eq 1
          @left_area_text = @left_area.elements.first
          @left_area_text_field = @left_area_text.fields.first
          expect(@left_area_text.fields.length).to eq 1
          expect(@left_area_text.name).to eq "Left Area Text"
          expect(@left_area_text.description).to eq \
            "Left Area Text description instructions"
          expect(@left_area_text.html_text).to eq "<%= filter(my_paragraph) %>"
          expect(@left_area_text_field.class).to eq Newsletter::Field::TextArea
          expect(@left_area_text_field.name).to eq "my_paragraph"
          expect(@left_area_text_field.description).to eq \
            "My Paragraph is a text area for you!"
          expect(@left_area_text_field.label).to eq "My Paragraph"
          click_link "Edit"
          expect(page).to have_content "Edit Element '#{@left_area_text.name}'"
          click_link "View All"
          click_link "Back to Design"
        end
        and_it "can create an element with a text field in the right area" do
          click_link "Manage Elements"
          click_link "New Newsletter Element"
          fill_in "Name", with: "Right Area Text"
          fill_in "Description", with: "Right Area Text description instructions"
          fill_in "HTML code", with: "<%= filter(my_paragraph) %>"
          click_link "Add Field"
          within(:css, "#new_field") do
            fill_in "Name", with: "my_text"
            fill_in "Label", with: "My Text"
            fill_in "Description", with: "My Text is a text area for you!"
            select "Text", from: "Type"
          end
          check "right_area"
          click_button "Submit"
          expect(Newsletter::Element.count).to eq 2
          @right_area.reload
          expect(@right_area.elements.count).to eq 1
          @right_area_text = @right_area.elements.first
          @right_area_text_field = @right_area_text.fields.first
          expect(@right_area_text.fields.length).to eq 1
          expect(@right_area_text.name).to eq "Right Area Text"
          expect(@right_area_text.description).to eq \
            "Right Area Text description instructions"
          expect(@right_area_text.html_text).to eq "<%= filter(my_paragraph) %>"
          expect(@right_area_text_field.class).to eq Newsletter::Field::Text
          expect(@right_area_text_field.name).to eq "my_text"
          expect(@right_area_text_field.description).to eq \
            "My Text is a text area for you!"
          expect(@right_area_text_field.label).to eq "My Text"
          click_link "Back to Design"
        end
        and_it "can create an element with an inline asset" do
          click_link "Manage Elements"
          click_link "New Newsletter Element"
          fill_in "Name", with: "Nice Image"
          fill_in "Description", with: "Image description instructions"
          fill_in "HTML code", with: "<%= image_tag nice_image.image.url %>"
          click_link "Add Field"
          within(:css, "#new_field") do
            fill_in "Name", with: "nice_image"
            fill_in "Label", with: "Nice Image"
            fill_in "Description", with: "Nice Image is an image for you!"
            select "Inlineasset", from: "Type"
          end
          check "right_area"
          check "left_area"
          click_button "Submit"
          expect(Newsletter::Element.count).to eq 3
          @right_area.reload
          @left_area.reload
          expect(@right_area.elements.count).to eq 2
          expect(@right_area.elements.count).to eq 2
          @nice_image = @left_area.elements.detect{|e| e.name.eql?('Nice Image')}
          expect(@nice_image.fields.length).to eq 1
          @nice_image_field = @nice_image.fields.first
          expect(@nice_image.name).to eq "Nice Image"
          expect(@nice_image.description).to eq \
            "Image description instructions"
          expect(@nice_image.html_text).to eq "<%= image_tag nice_image.image.url %>"
          expect(@nice_image_field.class).to eq Newsletter::Field::InlineAsset
          expect(@nice_image_field.name).to eq "nice_image"
          expect(@nice_image_field.description).to eq \
            "Nice Image is an image for you!"
          expect(@nice_image_field.label).to eq "Nice Image"
          click_link "Back to Design"
        end
        and_it "can delete an area" do
          area = @design.areas.first
          within(:css, "#area_#{area.id}") do
            click_link "Remove"
          end
          click_button "Submit"
          expect(Newsletter::Area.find_by_id(area.id)).to be_nil
          expect(Newsletter::Area.deleted.find_by_id(area.id)).not_to be_nil
        end
        and_it "soft deletes designs" do
          click_link "View All"
          click_link "Delete"
          expect(Newsletter::Design.count).to eq 0
          expect(Newsletter::Design.deleted.count).to eq 1
        end
      end
    end
  end
  it "can sort an element's fields" do
    pending "Not tested"
    design = import_design
    element = design.elements.detect{|e| e.name.eql?('Left Column Article')}
    visit "/newsletter/designs/#{design.id}/edit"
    click_link "Manage Elements"
    within(:css, "#element_1") do
      click_link "Edit"
    end
    raise "Not Tested"
  end
  it "paginates when there are a lot of them" do
    50.times{import_design(nil,Faker::Company.bs)}
    visit "/newsletter/designs"
    expect(page.body).to match /Next/
    expect(page.body).to match /Previous/
    click_link "Next"
  end
end
