class ReviewsController < ApplicationController

  before_filter :authenticate_user!, :only => [:new, :create]

  # GET /reviews
  # GET /reviews.xml
  def index
    if params[:product_id].blank?
      @reviews = Review.paginate :page => params[:page], :order => 'product_id ASC', :per_page => 20
    else
      @product = Product.find params[:product_id]

      order = 'product_id ASC'

      if params[:type].blank?
        if params['sort'] == 'negative'
          order = 'csi_score ASC'
        elsif params['sort'] == 'positive'
          order = 'csi_score DESC'
        end
        @reviews = @product.reviews.paginate :page => params[:page], :order => order, :per_page => 20
      elsif params[:type] == 's' || params[:type].try(:[], 0,1) == 's'
        if params['sort'] == 'negative'
          order = 'support_score ASC'
        elsif params['sort'] == 'positive'
          order = 'support_score DESC'
        end
        @reviews = @product.support_reviews(:order => order).paginate :page => params[:page], :per_page => 20
      elsif params[:type] == 'f' || params[:type].try(:[], 0,1) == 'f'
        if params['sort'] == 'negative'
          order = 'functionality_score ASC'
          logger.warn order
        elsif params['sort'] == 'positive'
          order = 'functionality_score DESC'
        end
        @reviews = @product.functionality_reviews(:order => order).paginate :page => params[:page], :per_page => 20
      elsif params[:type] == 'r' || params[:type].try(:[], 0,1) == 'r'
        if params['sort'] == 'negative'
          order = 'reliability_score ASC'
        elsif params['sort'] == 'positive'
          order = 'reliability_score DESC'
        end
        @reviews = @product.reliability_reviews(:order => order).paginate :page => params[:page], :per_page => 20
      else
        @reviews = []
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @reviews }
    end
  end

  # GET /reviews/1
  # GET /reviews/1.xml
  def show
    @review = Review.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @review }
    end
  end
  #
  # GET /reviews/new
  # GET /reviews/new.xml
  def new
    @review = Review.new
    @product = Product.find params[:product_id]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @review }
    end
  end

  # POST /reviews
  # POST /reviews.xml
  def create
    @review = Review.new(params[:review])
    respond_to do |format|
      if @review.create_review
				flash[:notice] = true
        format.html { redirect_to("/reviews?product_id=#{@review.product_id}") }
        format.xml  { render :xml => @review, :status => :created, :location => @review }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @review.errors, :status => :unprocessable_entity }
      end
    end
  end

  # # GET /reviews/1/edit
  # def edit
  #   @review = Review.find(params[:id])
  # end
  #
  #
  # # PUT /reviews/1
  # # PUT /reviews/1.xml
  # def update
  #   @review = Review.find(params[:id])
  #
  #   respond_to do |format|
  #     if @review.update_attributes(params[:review])
  #       flash[:notice] = 'Review was successfully updated.'
  #       format.html { redirect_to(@review) }
  #       format.xml  { head :ok }
  #     else
  #       format.html { render :action => "edit" }
  #       format.xml  { render :xml => @review.errors, :status => :unprocessable_entity }
  #     end
  #   end
  # end
  #
  # # DELETE /reviews/1
  # # DELETE /reviews/1.xml
  # def destroy
  #   @review = Review.find(params[:id])
  #   @review.destroy
  #
  #   respond_to do |format|
  #     format.html { redirect_to(reviews_url) }
  #     format.xml  { head :ok }
  #   end
  # end
end
