module Newsletter
  class FieldsController < ApplicationController
    layout 'admin'
  
    before_filter :find_field, :except => [:index, :new, :create]

    def index
      @fields = NewsletterField.find(:all)
    end

    def show
    end

    def new
      @field = NewsletterField.new
    end

    def edit
    end

    def create
      @field = Field.new(params[:newsletter_field])
      if @field.save
        flash[:notice] = 'NewsletterField was successfully created.'
        redirect_to(@field)  
      else
        render :action => "new"
      end
    end

    def update
      if @field.update_attributes(params[:newsletter_field])
        flash[:notice] = 'Field was successfully updated.'
        redirect_to(@field)
      else
        render :action => "edit"
      end
    end

    def destroy
      @field.destroy
      redirect_to(newsletter_fields_url)
    end
    
    protected
    
    def find_field
      @field = Field.find(params[:id])
    end
  end
end