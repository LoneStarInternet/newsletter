require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the Newsletter::NewsletterHelper. For example:
#
# describe Newsletter::NewsletterHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe Newsletter::NewslettersHelper, :type => :helper do
  describe "#is_email?" do
    it "returns true if params[:mode] is 'email'" do
      params[:mode] = 'email'
      expect(is_email?).to be true
    end
    it "returns false if params[:mode] is blank" do
      expect(is_email?).to be false
    end
    it "returns false if params[:mode] is not 'email'" do
      params[:mode] = 'editor'
      expect(is_email?).to be false
    end
  end
  describe "#filter" do
    it "converts newlines to br's" do
      expect(filter("bobo\njunk")).to eq "bobo<br/>junk"
    end
    it "converts emails to mailtos" do
      expect(filter("Bobo CLown bobo@example.com")).to eq \
        %Q|Bobo CLown <a href="mailto:bobo@example.com" target="_blank">bobo@example.com</a>|
    end
    it "converts urls to links" do
      expect(filter("Bobo CLown http://www.example.com funky chickens")).to eq \
        %Q|Bobo CLown <a href="http://www.example.com" target="_blank">http://www.example.com</a> funky chickens|
      expect(filter("Bobo CLown www.example.com funky chickens")).to eq \
        %Q|Bobo CLown <a href="http://www.example.com" target="_blank">www.example.com</a> funky chickens|
    end

    it "doesn't convert eols if you already have br's in your data" do
      expect(filter("bobo\njunk<br/>bobo")).to eq "bobo\njunk<br/>bobo"
    end

    it "doesn't convert your text for emails if you already have links" do
      text = %Q|Bobo CLown bobo@example.com <a href="#"></a>|
      expect(filter(text)).to eq text
    end

    it "doesn't replace for urls if you already have links" do
      text = %Q|Bobo CLown www.google.com <a href="#"></a>|
      expect(filter(text)).to eq text
    end
  end
  describe "#design_image" do
    it "returns an image tag for design's image directory" do
      design = import_design
      @newsletter = FactoryGirl.create(:newsletter, design: design)
      expect(design_image('newsletter_header.png',width: '100',class: 'neat_image')).to \
        eq(%Q|<img src="#{Newsletter.site_url}/images/#{
          design.name_as_path(design.name)
        }/newsletter_header.png" width="100" class="neat_image"/>|)
    end
  end
end
