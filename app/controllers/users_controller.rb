class UsersController < ApplicationController
  def create
    user = User.new user_params
    user.name = "Egor"
    if user.save
      # UserMailer.welcome_email(user).deliver
      sign_in user
      render :json => { :success => true, info: 'User created', user: user }, status: 200
    else
      puts 'errors while update user'
      render :json => { :success => false, info: 'User not created', user: nil, errors: user.errors }, status: 200
    end
  end

  def show
  end

  def destroy
  end

  def update
    user = User.find params[:id]
    if user.update_attributes user_params
      render :json => { :success => true, info: 'User updated', user: user }, status: 200
    else
      render :json => { :success => false, info: 'User not updated', user: user, errors: user.errors }, status: 200
    end
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name)
  end
end
