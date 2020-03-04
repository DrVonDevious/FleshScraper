
class GamesController < ApplicationController
  
  skip_before_action :verify_authenticity_token, only: [:create]

  def random
    Cell.delete_all
    Game.delete_all
    Zombie.delete_all
    Obstacle.delete_all
    GameObject.delete_all
    @game = Game.create
    @game.generate
  end

  def play
    @game = Game.find_by(params[:id])
  end

  def index
    @games = current_user.games
  end

  def menu
  end

  def new
    @game = Game.new
  end

  def create
    Game.delete_all
    game = Game.new(game_params)
    game.save
    game.update(user_id: session[:user_id], is_running: true)
    session[:game_id] = game.id
    game.generate("Arthur")
    redirect_to "/games/#{game.id}/play"
  end

  def show_field
    @game = Game.first
  end

  def move_player
    @game = Game.find_by(id: session[:game_id])
    @game.move_player(params[:direction])
    @game.make_a_turn
    redirect_to "/games/#{@game.id}/play"
  end

  def next_turn
    @game = Game.find_by(params[:id])
    @game.make_a_turn
    redirect_to "/games/#{@game.id}/play"
  end

  private

  def game_params
    params.require(:game).permit(:board_width, :board_heigth,
                                 :initial_zombies, :initial_npc,
                                 :current_score, :is_running,
                                 :user_id)
  end



end
