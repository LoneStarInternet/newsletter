module Newsletter
  class NewslettersController < ::Newsletter::ApplicationController
    helper_method :newsletter
    def sort
      Newsletter.all.each do | newsletter |
        newsletter.sequence = params["newsletters"].index(newsletter.id.to_s)+1
        newsletter.save
      end
      head :ok
    end
  
    def archive
      @newsletters = Newsletter.published
      render :layout => ::Newsletter.archive_layout
    end

    def stylesheet

    end
  
    def publish
      if @newsletter.publish
        flash[:notice] = 'Newsletter Published'
      else
        flash[:notice] = @newsletter.errors
      end
      redirect_to(newsletters_path)
    end
  
    def unpublish
      if @newsletter.unpublish
        flash[:notice] = 'Newsletter UnPublished'
      else
        flash[:notice] = @newsletter.errors
      end 
      redirect_to(newsletters_path)
    end
  
    def index
      @newsletters = ::Newsletter::Newsletter.active.order('created_at desc, published_at desc').paginate(:page => params[:page])
    end
  
    def show
      return redirect_to(main_app.newsletter_archive_path) unless @newsletter.present?
      respond_to do |format|
        format.html { render layout: false }
        format.css  { render layout: false, content_type: 'text/css' }
      end
    end

    def editor
      params[:editor] = '1'
      render :show, layout: false
    end

    def new
      @newsleter = Newsletter.new
      @designs = Design.active
    end

    def edit
      @designs = Design.active
    end

    def create
      @newsletter = Newsletter.new(params[:newsletter])
      if @newsletter.save
        flash[:notice] = 'Newsletter was successfully created.'
        redirect_to(edit_newsletter_path(@newsletter))
      else
        @designs = Design.active
        render :action => "new"
      end
    end

    def update
      if @newsletter.update_attributes(params[:newsletter])
        flash[:notice] = 'Newsletter was successfully updated.'
        redirect_to(edit_newsletter_path(@newsletter))
      else
        @designs = Design.active
        render :action => "edit"
      end
    end

    def destroy
      @newsletter.destroy
      redirect_to(newsletters_url)
    end

  end
end
