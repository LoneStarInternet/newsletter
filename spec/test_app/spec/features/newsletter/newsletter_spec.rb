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

  it "allows you to edit a pieces", js: true do
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
end
