
class GamesController < ApplicationController
  
  def random
    Cell.delete_all
    Game.delete_all
    Zombie.delete_all
    Obstacle.delete_all
    @game = Game.create
    @game.generate
  end

  def index
  end

  def menu
  end

  def new
  end

  def create
  end

end
