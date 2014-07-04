class UsersController < ApplicationController
  before_action :signed_in_user, :only => [:edit, :update, :show, :destroy]

  def create
    @user = User.new user_params
    if @user.save
      UserMailer.welcome_email(@user).deliver
      sign_in @user
      render 'create_success'
    else
      render 'create_error'
    end
  end

  def show
    @user = User.find params[:id]
  end

  def destroy
  end

  def update
    @user = User.find params[:id]
    @user.skip_password_validation = true
    if @user.update_attributes user_params
      render 'update_success'
    else
      render 'update_error'
    end
  end

  def send_verify_email
    user = User.find params[:id]
    if user.send_confirm_email
      render :json => { :success => true, info: 'Verify email was sent' }, status: 200
    else
      render :json => { :success => false, info: 'Verify email was not sent', errors: user.errors }, status: 200
    end
  end

  def confirm_email
    @user = current_user
    if @user.confirm_email params[:token]
      render 'confirm_email_success'
    else
      @errors = @user.errors
      render 'confirm_email_error'
    end
  end

  def change_password
    @user = User.find params[:id]
    if @user.change_password params[:user]
      render 'change_password_success'
    else
      render :json => { :success => false, info: 'Password not changed', errors: @user.errors }, status: 200
    end
  end

  def create_password
    @user = User.find params[:id]
    if @user.create_password params[:user]
      render 'change_password_success'
    else
      render :json => { :success => false, info: 'Password not created', errors: @user.errors }, status: 200
    end
  end

  private
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :name)
    end

    def signed_in_user
      render :json => {status: 'unath'}, status: 401 unless signed_in?
    end
end
