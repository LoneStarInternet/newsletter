require 'rails_helper'

RSpec.describe Newsletter::Piece do
  before(:each) do 
    @design = import_design
    @newsletter = FactoryGirl.create(:newsletter, design: @design)
  end
  it "can answer for its fields' methods" do
    piece = Newsletter::Piece.find(@newsletter.pieces.first.id)
    image = piece.image #should method_missing
    expect(image).to eq piece.locals[:image]
  end

  it "can respond to things that are in its locals hash" do
    piece = Newsletter::Piece.find(@newsletter.pieces.first.id)
    expect(piece.respond_to?(:image)).to be true
  end

  it "can respond to things that are its actual methods" do
    piece = Newsletter::Piece.find(@newsletter.pieces.first.id)
    expect(piece.respond_to?(:fields)).to be true
  end

  it "doesn't respond to garbage methods or non-locals" do
    piece = Newsletter::Piece.find(@newsletter.pieces.first.id)
    expect(piece.respond_to?(:funk)).to be false
  end

  it "raises exception to bad method calls" do
    piece = Newsletter::Piece.find(@newsletter.pieces.first.id)
    expect{piece.funk}.to raise_error
  end
end
