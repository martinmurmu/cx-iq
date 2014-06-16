class UsersController < ApplicationController
  before_filter :require_admin

  def index
    @users = User.paginate(:page => params[:page], :per_page => 50)
  end


  def login_as
    if current_user.id == params['id'].to_i
      redirect_to root_path
    else
      new_user = User.find(params['id'])
      sign_out(current_user)
      sign_in_and_redirect(new_user)
    end
  end

end
