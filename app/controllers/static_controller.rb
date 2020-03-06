class StaticController < ApplicationController

  skip_before_action :authorized, only: [:home, :about, :leaderboard]

  def home
  end

  def about
  end

  def leaderboard
    @games = Game.all
  end

end
