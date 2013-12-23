module Newsletter
  class NewslettersController < ApplicationController
    skip_before_filter :authorize, :only => ["archive","show"]
    before_filter :find_newsletter, :only => [:publish,:unpublish,:edit,:update,:destroy,:show]
    #FIXME: why do we need to place this custom code here instead of reopening the class?
    skip_before_filter :authenticate, :only => [:archive,:show]
  
  
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
      return redirect_to(archive_path) unless @newsletter.present?
      newsletter_html = render_to_string :inline => File.readlines(@newsletter.design.view_path).join, 
        :locals => @newsletter.locals
      if params[:mode].eql?('email')
        #mailer handles substitutions
        render :text => newsletter_html
      else
        #no substitutions
        render :text => newsletter_html
      end
    end

    def new
      @newsletter = Newsletter.new
      @designs = Design.active
    end

    def edit
      @designs = Design.active
    end

    def create
      @newsletter = Newsletter.new(params[:newsletter_newsletter])
      if @newsletter.save
        flash[:notice] = 'Newsletter was successfully created.'
        redirect_to(edit_newsletter_path(@newsletter))
      else
        @designs = Design.active
        render :action => "new"
      end
    end

    def update
      if @newsletter.update_attributes(params[:newsletter_newsletter])
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
  
    protected 
    def find_newsletter
      @newsletter = Newsletter.find_by_id(params[:id])
    end
  end
end
