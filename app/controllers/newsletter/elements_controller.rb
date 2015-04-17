module Newsletter
  class ElementsController < ::Newsletter::ApplicationController
    before_filter :find_element, :except => [:new,:create,:index]
    before_filter :find_design
    before_filter :find_fields, :except => [:new,:create,:index]
    before_filter :find_field_types, :only => [:new,:create,:edit,:update]
    include DeleteableActions  

    def index
      @elements = @design.elements.
        by_design(@design).paginate(:page => params[:page])
    end

    def new
      @element = Element.new
      @fields = [Field.new]
    end

    def edit
    end

    def create
      @element = Element.new(params[:element])
      @element.design = @design

      respond_to do |format|
        if @element.save
          flash[:notice] = 'Element was successfully created.'
          format.html { redirect_to(design_elements_path(@design)) }
          format.xml  { render :xml => @element, :status => :created, :location => @element }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @element.errors, :status => :unprocessable_entity }
        end
      end
    end
    
    def update
      respond_to do |format|
        if @element.update_attributes(params[:element])
          flash[:notice] = 'Element was successfully updated.'
          format.html { redirect_to(design_elements_path(@design)) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @element.errors, :status => :unprocessable_entity }
        end
      end
    end

    def destroy
      @element.destroy
      redirect_to(design_elements_path(@design))
    end
  
    protected
    def find_element
      @element ||= Element.find_by_id(params[:id])
    end
  
    def find_design
      return @design ||= @element.design if @element && @element.design.present?
      @design ||= Design.find_by_id(params[:design_id])
    end
  
    def find_fields
      return @fields ||= @element.fields if @element && @element.fields.present?
      @fields ||= [Field.new]
    end
  
    def find_field_types
      @field_types ||= Field.valid_types
    end
  end
end
