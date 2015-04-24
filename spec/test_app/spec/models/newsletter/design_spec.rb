require 'rails_helper'

RSpec.describe Newsletter::Design do
  before(:each) do 
    @design = import_design(nil,"My Design")
  end

  it "sets the name correctly" do
    expect(@design.name).to eq("My Design")
  end

  context "whether it exports and imports correctly" do
    it "doesn't blow up" do
      reimported_design = nil
      Tempfile.open(["design", ".yml"], 'tmp') do |design_file|
        design_file.close
        @design.export(design_file.path)
        reimported_design = Newsletter::Design.import(design_file.path, 
          "My Re-Imported Design"
        )
      end
      and_it "has the same elements" do
        expect(@design.elements.pluck(:name).sort).to eq reimported_design.elements.
          pluck(:name).sort
      end
      and_it "knows its images" do
        expect(@design.images).to include("newsletter_header.png")
      end
    end
    
  end
end
