module Newsletter 
  class AreasController < ApplicationController
    
    before_filter :find_area, :except => [:create, :new, :index]
    before_filter :find_design, :except => [:destroy,:sort]
  
    def sort
      @newsletter = Newsletter.find(params[:newsletter_id])
      @area.pieces.active.by_newsletter(@newsletter).each do | piece |
        piece.update_attribute(:sequence, params["newsletter_piece"].index(piece.id.to_s).to_i+1)
      end
      head :ok
    end
  
    def index
      @areas = Area.find(:all)
    end

    def show
    end

    def new
      @newsletter_area = Area.new
    end

    def edit
    end

    def create
      @newsletter_area = Area.new(params[:newsletter_area])
      if @newsletter_area.save
        flash[:notice] = 'Area was successfully created.'
          redirect_to(@newsletter_area)
      else
          render :action => "new"
      end
    end

    def update
      if @newsletter_area.update_attributes(params[:newsletter_area])
        flash[:notice] = 'Area was successfully updated.'
        redirect_to(@newsletter_area) 
      else
        render :action => "edit"
      end
    end

    def destroy
      @newsletter_area.destroy
      redirect_to(areas_url)
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
