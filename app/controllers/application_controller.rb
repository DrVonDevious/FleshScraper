class ApplicationController < ActionController::Base

  before_action :authorized
  helper_method :current_user
  helper_method :logged_in?

  def set_object(model)
    model.find(params[:id])
  end

  def current_user
    User.find_by(id: session[:user_id])
  end

  def logged_in?
    !current_user.nil?
  end

  def authorized
    redirect_to '/' if !logged_in?
  end

end
