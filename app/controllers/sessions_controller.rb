class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email params[:session][:email].downcase
    if user && user.authenticate(params[:session][:password])
      sign_in user
      @user = current_user
      render :show_current_user
    else
      render :json => {:success => false, info: 'Log in failed', user: nil}, status: 200
    end
  end

  def destroy
    sign_out
    render :json => {
      :success => true,
      :info => "Logged out",
      :csrfParam => request_forgery_protection_token,
      :csrfToken => form_authenticity_token
      }, :status => 200
  end

  def show_current_user
    @user = current_user
  end
end
