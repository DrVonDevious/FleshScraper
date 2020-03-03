
class GamesController < ApplicationController
  
  def random
    Cell.delete_all
    Game.delete_all
    Zombie.delete_all
    Obstacle.delete_all
    @game = Game.create
    @game.generate
  end



<<<<<<< HEAD


=======
>>>>>>> 327c2687fb6c9d4f06ba8d6188cdca207bfce487
  def index
  end


end
