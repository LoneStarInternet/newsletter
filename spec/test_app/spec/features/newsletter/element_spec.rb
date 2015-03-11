require 'spec_helper'

RSpec.describe 'Element management', type: :feature do
  before(:each) do
    @design = import_design
    @newsletter = FactoryGirl.create(:newsletter, design: @design)
  end

  it "creates an element correctly", js: true do
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
