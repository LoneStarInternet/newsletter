require 'nested_form'
module Newsletter
  class DesignsController < ::Newsletter::ApplicationController
    before_filter :find_design, :except => [:new, :create, :index]

    include DeleteableActions

    def index
      @designs = Design.order(:name).paginate(page: (params[:page] || 1), 
        per_page: (params[:per_page] || 30))
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
      @design = Design.new(params[:design])
      if @design.save
        flash[:notice] = 'Design was successfully created.'
        redirect_to(edit_design_path(@design))
      else
          render :action => "new"
      end
    end

    def update
      if @design.update_attributes(params[:design])
        flash[:notice] = 'Design was successfully updated.'
        redirect_to(edit_design_path(@design))
      else
        render :action => "edit"
      end
    end

    def destroy
      @design.delete
      redirect_to(designs_url)
    end
    
    protected
    
    def find_design
      @design = Design.find(params[:id])
    end
  end
end
