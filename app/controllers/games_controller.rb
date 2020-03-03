class GamesController < ApplicationController
  
  def random
    Cell.destroy_all
    Game.destroy_all
    Zombie.destroy_all
    Obstacle.destroy_all
    @game = Game.create
    @game.generate
  end
end
