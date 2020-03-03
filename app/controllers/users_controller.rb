class UsersController < ApplicationController

  skip_before_action :authorized, only: [:new, :create, :index]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.valid?
      @user.save
      session[:user_id] = @user.id
      redirect_to '/'
    else
      redirect_to '/users/new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation, :email)
  end

end
