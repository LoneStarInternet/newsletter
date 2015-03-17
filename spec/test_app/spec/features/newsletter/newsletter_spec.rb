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
    visit "/newsletter/newsletters/#{newsletter.id}/edit" 
    fill_in "Name", with: new_name
    click_button "Save"
    Debugging::wait_until_success do
      @newsletter.reload
      expect(@newsletter.name).to eq(new_name)
    end
  end
end
