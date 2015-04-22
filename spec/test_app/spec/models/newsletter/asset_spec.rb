require 'rails_helper'

RSpec.describe Newsletter::Asset do
  before(:each) do
    Newsletter::AssetUploader.enable_processing = true
  end
  it "knows if it is an image" do
    asset = FactoryGirl.create(:asset)
    # default factory assumes image
    expect(asset.is_image?).to be true
  end
  it "knows if it is not an image" do
    asset = FactoryGirl.create(:asset,
      image: File.open(File.join(Rails.root, 
      '/spec/support/files/test.pdf'))
    )
    # default factory assumes image
    expect(asset.is_image?).to be false
  end
  after(:each) do
    Newsletter::AssetUploader.enable_processing = false
  end
end
