module Newsletter
  class DesignsController < ApplicationController
    layout 'admin'
    before_filter :find_design, :except => [:new, :create, :index]

    def index
      @designs = Design.find(:all)
    end

    def show
      @areas = @design.areas.active
    end

    def new
      @design = Design.new
    end

    def edit
    end

    def create
      @design = Design.new(params[:newsletter_design])
      if @design.save
        flash[:notice] = 'Design was successfully created.'
        redirect_to(edit_newsletter_design_path(@design))
      else
          render :action => "new"
      end
    end

    def update
      if @design.update_attributes(params[:newsletter_design])
        flash[:notice] = 'Design was successfully updated.'
        redirect_to(edit_newsletter_design_path(@design))
      else
        render :action => "edit"
      end
    end

    def destroy
      @design.destroy
      redirect_to(newsletter_designs_url)
    end
    
    protected
    
    def find_design
      @design = Design.find(params[:id])
    end
  end
end