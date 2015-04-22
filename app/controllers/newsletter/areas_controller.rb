module Newsletter 
  class AreasController < ::Newsletter::ApplicationController
    
    before_filter :find_area, :except => [:create, :new, :index]
    before_filter :find_design, :except => [:destroy,:sort]
  
    def sort
      @newsletter = Newsletter.find(params[:newsletter_id])
      @area.pieces.active.by_newsletter(@newsletter).each do | piece |
        piece.update_attribute(:sequence, params["piece"].index(piece.id.to_s).to_i+1)
      end
      head :ok
    end
  
    protected
  
    def find_design
      @design = Design.find(params[:design_id])
    end
    
    def find_area
      @area = Area.find(params[:id])
    end
  end
end
