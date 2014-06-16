class AuthController < ApplicationController

  def verify_token
    render :json => {:userName => User.authenticate_with_token(:auth_token => params[:token]).email}.to_json
  end

end
