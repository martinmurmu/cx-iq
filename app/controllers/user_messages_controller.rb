class UserMessagesController < ApplicationController
  # GET /user_messages
  # GET /user_messages.xml
#  def index
#    @user_messages = UserMessages.all
#
#    respond_to do |format|
#      format.html # index.html.erb
#      format.xml  { render :xml => @user_messages }
#    end
#  end

  def index
    redirect_to :action=>'new'
  end

  def thank_you

    
  end

  # GET /user_messages/1
  # GET /user_messages/1.xml
#  def show
#    @user_messages = UserMessages.find(params[:id])
#
#    respond_to do |format|
#      format.html # show.html.erb
#      format.xml  { render :xml => @user_messages }
#    end
#  end

  # GET /user_messages/new
  # GET /user_messages/new.xml
  def new
    @user_messages = UserMessages.new

    respond_to do |format|
      format.html # new.html.erb
#      format.xml  { render :xml => @user_messages }
    end
  end

  # GET /user_messages/1/edit
#  def edit
#    @user_messages = UserMessages.find(params[:id])
#  end

  # POST /user_messages
  # POST /user_messages.xml
  def create
    @user_messages = UserMessages.new(params[:user_messages])
    if !verify_recaptcha 
      flash[:error] = "Wrong captcha"
      respond_to do |format|
        format.html { render :action => "new" }
      end
      return
    end

    respond_to do |format|
      if @user_messages.save

	    recipient = 'greg@amplifiedanalytics.com'
	    #recipient = 'talrep@gmail.com'
	    subject = "New Contact message"
	    message = "From: #{@user_messages.name}\n Email: #{@user_messages.email}\nCompany: #{@user_messages.company}\nMessage:\n#{@user_messages.message}"
        Emailer.deliver_contact(recipient, subject, message)
        return if request.xhr?

#        flash[:notice] = 'UserMessages was successfully created.'
        format.html { render :action => 'thank_you' }
#        format.xml  { render :xml => @user_messages, :status => :created, :location => @user_messages }
      else
        format.html { render :action => "new" }
#        format.xml  { render :xml => @user_messages.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /user_messages/1
  # PUT /user_messages/1.xml
#  def update
#    @user_messages = UserMessages.find(params[:id])
#
#    respond_to do |format|
#      if @user_messages.update_attributes(params[:user_messages])
#        flash[:notice] = 'UserMessages was successfully updated.'
#        format.html { redirect_to(@user_messages) }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @user_messages.errors, :status => :unprocessable_entity }
#      end
#    end
#  end

  # DELETE /user_messages/1
  # DELETE /user_messages/1.xml
#  def destroy
#    @user_messages = UserMessages.find(params[:id])
#    @user_messages.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(user_messages_url) }
#      format.xml  { head :ok }
#    end
#  end
end
