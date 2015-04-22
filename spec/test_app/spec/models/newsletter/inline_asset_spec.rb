require 'rails_helper'

RSpec.describe Newsletter::Field::InlineAsset do
  before(:each) do
    Newsletter::AssetUploader.enable_processing = true
    @design = import_design
  end
  it "knows if it is an image" do
    newsletter = FactoryGirl.create(:newsletter_with_image_asset, design: @design)
    newsletter = Newsletter::Newsletter.find(newsletter.id)
    piece = newsletter.pieces.first
    local = piece.locals[:image]
    # default factory assumes image
    expect(local.is_image?).to be true
  end
  it "knows if it is not an image" do
    newsletter = FactoryGirl.create(:newsletter_with_pdf_asset, design: @design)
    newsletter = Newsletter::Newsletter.find(newsletter.id)
    piece = newsletter.pieces.first
    local = piece.locals[:image]
    # default factory assumes image
    expect(local.is_image?).to be false
  end
  it "url only knows if it is an image" do
    newsletter = FactoryGirl.create(:newsletter, design: @design)
    newsletter = Newsletter::Newsletter.find(newsletter.id)
    piece = newsletter.pieces.first
    local = piece.locals[:image]
    # default factory assumes image
    expect(local.is_image?).to be true
  end
  it "url only knows if it is not an image" do
    newsletter = FactoryGirl.create(:newsletter_with_pdf_url, design: @design)
    newsletter = Newsletter::Newsletter.find(newsletter.id)
    piece = newsletter.pieces.first
    local = piece.locals[:image]
    # default factory assumes image
    expect(local.is_image?).to be false
  end
  after(:each) do
    Newsletter::AssetUploader.enable_processing = false
  end
end
