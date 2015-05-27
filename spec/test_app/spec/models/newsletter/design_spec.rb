require 'rails_helper'

RSpec.describe Newsletter::Design do
  before(:each) do 
    FileUtils.rm_rf(File.join(Rails.root, 'public', 'images', 'My_Design'))
    @design = import_design(nil,"My Design")
  end

  it "sets the name correctly" do
    expect(@design.name).to eq("My Design")
  end

  context "when name changed/moved" do
    it "moves its images" do
      old_images_path = @design.images_path
      old_name = @design.name
      expect(@design.images_path).to include("public/images/#{@design.name_as_path(@design.name)}")
      expect(File.exist?(@design.images_path)).to be true
      new_name = @design.name + " NEW!"
      FileUtils.rm_rf(File.join(Newsletter.designs_path,'designs',
        'My_Design_NEW_'))
      FileUtils.rm_rf(File.join(Rails.root, 'public', 'images', 
        'My_Design_NEW_'))
      expect{@design.update_attributes(name: new_name)}.not_to raise_error
      expect(@design.name).to eq new_name
      expect(@design.images_path).to include("public/images/#{@design.name_as_path(new_name)}")
      expect(File.exist?(old_images_path)).to be false
      expect(File.exist?(@design.images_path)).to be true
    end
  end

  context "has an associated stylesheet" do
    it "that is accessible" do
      expect{@design.stylesheet_text}.not_to raise_error
    end
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
        expect(reimported_design.elements.pluck(:name).sort).to eq @design.
          elements.pluck(:name).sort
      end
      and_it "knows its images" do
        expect(reimported_design.images).to include("newsletter_header.png")
      end
      and_it "knows its stylesheet" do
        expect(reimported_design.stylesheet_text).to eq @design.stylesheet_text
      end
    end
    
  end
end
