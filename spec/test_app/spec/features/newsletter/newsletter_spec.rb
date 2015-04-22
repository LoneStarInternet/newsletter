require 'rails_helper'

RSpec.feature 'Newsletter generation' do
  before(:each) do
    @design = import_design
    @newsletter = FactoryGirl.create(:newsletter, design: @design)
  end

  it "has javascript available in editor" do
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

  it "allows you to edit its name" do
    new_name = nil
    begin ;new_name=Faker::Company.name; end while(new_name.eql?(@newsletter.name)) 
    expect(new_name).not_to eq(@newsletter.name)
    visit "/newsletter/newsletters/#{@newsletter.id}/edit" 
    fill_in "Name", with: new_name
    click_button "Save"
    Debugging::wait_until_success do
      @newsletter.reload
      expect(@newsletter.name).to eq(new_name)
    end
  end

  it "allows you to edit a piece", js: true do
    visit "/newsletter/newsletters/#{@newsletter.id}/edit" 
    piece = @newsletter.pieces.first
    current_url = piece.locals[:image].url
    new_url = Faker::Internet.url 

    within_frame 'preview' do
      find(:css, "#piece_#{piece.id}").hover()
      find(:css, "#piece_#{piece.id} .edit_link").click()
    end

    fill_in "Url:", with: new_url
    click_button "Submit"
    Debugging::wait_until_success do
      piece = Newsletter::Piece.find(piece.id)
      expect(piece.locals[:image].url).to eq new_url
    end
  end

  it "allows you to remove an inline asset from a piece", js: true do
    Newsletter::AssetUploader.enable_processing = true
    visit "/newsletter/newsletters/#{@newsletter.id}/edit" 
    area = @newsletter.area('left_column')
    element = area.elements.detect{|e| e.name.eql?('Left Column Article')}
    field = element.fields.detect{|f| f.name.eql?('link')}
    select "Left Column Article", from: "Area: Left column" 
    click_button "add_element_#{area.id}"
    fill_in "Article Excerpt:", with: Faker::Lorem.paragraphs.join("\n\n")
    fill_in "Headline:", with: Faker::Company.bs.split(/ /).map(&:capitalize).join(" ")
    find(:css, "#piece_field_values_attributes_#{field.id}_uploaded_data").set(
      Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, 
      '/spec/support/files/iReach_logo.gif'))).path
    )
    click_button "Submit"

    @newsletter = Newsletter::Newsletter.find(@newsletter.id)
    piece = @newsletter.pieces.last
    file_location = piece.locals[:link].asset.image.to_s
    expect(File.exist?(file_location)).to be true

    within_frame 'preview' do
      find(:css, "#piece_#{piece.id}").hover()
      find(:css, "#piece_#{piece.id} .edit_link").click()
    end

    field = piece.fields.detect{|f| f.name.eql?('link')}
    within(:css, "#piece_field_values_attributes_#{field.id}") do
      click_link "Delete Asset"
    end
    click_button "Submit"
    @newsletter = Newsletter::Newsletter.find(@newsletter.id)
    piece = @newsletter.pieces.last
    expect(piece.locals[:link].asset).to be nil
    expect(File.exist?(file_location)).to be false

    Newsletter::AssetUploader.enable_processing = false
  end

  it "doesn't break when you put double quotes in a piece text field", js: true do
    visit "/newsletter/newsletters/#{@newsletter.id}/edit" 
    area = @newsletter.area('right_column')
    element = area.elements.detect{|e| e.name.eql?('Right Column Headline')}
    field = element.fields.first
    @newsletter.pieces << Newsletter::Piece.new({
      area_id: area.id,
      element_id: element.id,
      field_values_attributes: {
        field.id => {
          text: '"bunk" is good!'
        }
      }
    })
    piece = @newsletter.pieces.last
    visit "/newsletter/newsletters/#{@newsletter.id}/edit"

    within_frame 'preview' do
      find(:css, "#piece_#{piece.id}").hover()
      find(:css, "#piece_#{piece.id} .edit_link").click()
    end

    expect(find(:css, "#piece_field_values_attributes_#{field.id}_text")[:value]).to eq\
      '"bunk" is good!'
  end
end
