module Newsletter
  class PiecesController < ::Newsletter::ApplicationController
    before_filter :find_newsletter
    before_filter :find_element
    before_filter :find_area

    def new
      @piece = Piece.new({
        :area_id => @area.id,
        :element_id => @element.id,
        :newsletter_id => @newsletter.id
      })
    end

    def edit
    end

    def create
      @piece = Piece.new(params[:piece])
      if @piece.save
        flash[:notice] = 'Piece was successfully created.'
        redirect_to(edit_newsletter_path(@newsletter))
      else
        render :action => "new"
      end
    end

    def update
      if @piece.update_attributes(params[:piece])
        flash[:notice] = 'Piece was successfully updated.'
        redirect_to(edit_newsletter_path(@newsletter))
      else
        render :action => "edit"
      end
    end

    def destroy
      @piece.destroy
      redirect_to(edit_newsletter_path(@newsletter))
    end
  
    protected 
  
    def find_newsletter
      @newsletter ||= (@piece.try(:newsletter) || 
        ::Newsletter::Newsletter.find(params[:newsletter_id] || 
        params[:piece][:newsletter_id]))
    end
  
    def find_element
      @element ||= (@piece.try(:element) || 
        Element.find(params[:element_id] || params[:piece][:element_id]))
    end
  
    def find_area
      @area ||= (@piece.try(:area) || 
        Area.find(params[:area_id] || params[:piece][:area_id]))
    end
  end
end
