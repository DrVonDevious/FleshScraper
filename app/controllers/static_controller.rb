class StaticController < ApplicationController

  skip_before_action :authorized, only: [:home, :about]

  def home
  end

  def about
  end

end
