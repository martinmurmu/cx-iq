class WomRequestsController < ApplicationController
  # GET /wom_requests
  # GET /wom_requests.xml
  def index
    redirect_to :action=>'new'
  end

  def thank_you


  end

  # GET /wom_requests/1
  # GET /wom_requests/1.xml
#  def show
#    @wom_request = WomRequest.find(params[:id])
#
#    respond_to do |format|
#      format.html # show.html.erb
#      format.xml  { render :xml => @wom_request }
#    end
#  end

  # GET /wom_requests/new
  # GET /wom_requests/new.xml
  def new
    @wom_request = WomRequest.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @wom_request }
    end
  end

  # GET /wom_requests/1/edit
#  def edit
#    @wom_request = WomRequest.find(params[:id])
#  end

  # POST /wom_requests
  # POST /wom_requests.xml
  def create
    @wom_request = WomRequest.new(params[:wom_request])
    
    captcha_ok = verify_nice_captcha #to generate 'try again' on recaptcha
    if !captcha_ok
      @wom_request.errors.add_to_base "Wrong captcha"
    end

    respond_to do |format|
      if captcha_ok and @wom_request.save
        recipient = 'greg@amplifiedanalytics.com'
	    subject = "New WOM request message"
	    message = "Email: #{@wom_request.email}\nCompany: #{@wom_request.company_name}\nProduct Name:\n#{@wom_request.product_name}\nCompetitor1: #{@wom_request.competitor_a}\nCompetitor2: #{@wom_request.competitor_b}\nCompetitor3: #{@wom_request.competitor_c}\nCompetitor4: #{@wom_request.competitor_d}\nUpdate Frequency: #{@wom_request.update_frequency}"
        Emailer.deliver_wom_request(recipient, subject, message)
        return if request.xhr?
        flash[:notice] = 'WomRequest was successfully created.'
#        format.html { redirect_to(@wom_request) }
        format.html { render :action => 'thank_you', :controller => 'user_messages' }
#        format.xml  { render :xml => @wom_request, :status => :created, :location => @wom_request }
      else
        format.html { render :action => "new" }
#        format.xml  { render :xml => @wom_request.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /wom_requests/1
  # PUT /wom_requests/1.xml
#  def update
#    @wom_request = WomRequest.find(params[:id])
#
#    respond_to do |format|
#      if @wom_request.update_attributes(params[:wom_request])
#        flash[:notice] = 'WomRequest was successfully updated.'
#        format.html { redirect_to(@wom_request) }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @wom_request.errors, :status => :unprocessable_entity }
#      end
#    end
#  end

  # DELETE /wom_requests/1
  # DELETE /wom_requests/1.xml
#  def destroy
#    @wom_request = WomRequest.find(params[:id])
#    @wom_request.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(wom_requests_url) }
#      format.xml  { head :ok }
#    end
#  end
end
