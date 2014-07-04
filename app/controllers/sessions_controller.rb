class SessionsController < ApplicationController

  def create
    user = User.find_by_email params[:session][:email].downcase
    if user && user.authenticate(params[:session][:password])
      sign_in user
      render :json => {
        success: true,
        info: 'current user',
        current_user: {
          id: current_user.id,
          name: current_user.name
        }
      }
    else
      render :json => {success: false, info: 'authentication error', current_user: nil}, status: 200
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
    if signed_in?
      render :json => {
        success: true,
        info: 'current user',
        current_user: {
          id: current_user.id,
          name: current_user.name
        }
      }
    else
      render :json => { success: false, info: 'current user', current_user: nil }
    end
  end

  def vk_auth
    u = Vkontakte.new params[:code]
    u.load
    user = User.find_by_vk_uid u.uid
    if user
      # войти
      sign_in user
      redirect_to root_path
    else
       # создать и войти
      user_params = u.parse.user
      user = User.new user_params
      user.skip_password_validation = true
      user.skip_email_validation = true
      if user.save
        sign_in user
        redirect_to root_path
      else
        redirect_to root_path
      end
    end

  end
end
