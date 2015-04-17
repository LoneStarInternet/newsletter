require "rails_helper"

RSpec.describe Newsletter::PiecesController, :type => :routing do
  describe "routing" do
    routes {Newsletter::Engine.routes}

    it "routes to #new" do
      expect(:get => "/newsletters/2/pieces/new").to route_to("newsletter/pieces#new", :newsletter_id => "2")
    end

    it "routes to #edit" do
      expect(:get => "/pieces/1/edit").to route_to("newsletter/pieces#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/pieces").to route_to("newsletter/pieces#create")
    end

    it "routes to #update" do
      expect(:put => "/pieces/1").to route_to("newsletter/pieces#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/pieces/1").to route_to("newsletter/pieces#destroy", :id => "1")
    end

  end
end
