require 'rails_helper'

RSpec.describe Newsletter::Newsletter do
  include Capybara::DSL
  before(:each) do
    @design = import_design
    @newsletter = FactoryGirl.create(:newsletter, design: @design)
  end

  # we need a real web server running ... easy way to do it js: true
  context "when generating newsletters for emails", js: true do
    before(:each) do
      visit "/newsletters/#{@newsletter.id}/public" 
    end
    it "contains its pieces" do
      @newsletter.pieces.each do |piece|
        piece.fields.each do |field|
          expect(@newsletter.generate(:email)).to include(field.get_value(piece)) 
        end
      end
    end

    it "doesn't contain javascript" do
      expect(@newsletter.generate(:email)).not_to include('<script>')
    end
  end
end
