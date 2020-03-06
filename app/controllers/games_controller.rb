
class GamesController < ApplicationController

  skip_before_action :verify_authenticity_token, only: [:create]

  helper_method :player_stats, :player_score

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
    @game = Game.find_by(id: params[:id])
  end

  def index
    @games = current_user.games
    @players = GameObject.where(game_type: "player")
  end

  def menu
  end

  def continue
    @user = User.find_by(id: session[:user_id])
    @players = GameObject.where(game_type: "player")
  end

  def new
    @game = Game.new
  end

  def create
    game = Game.new(game_params)
    game.save
    game.update(user_id: session[:user_id], is_running: true)
    session[:game_id] = game.id
    game.generate(params[:game][:name])
    redirect_to "/games/#{game.id}/play"
  end
  
  def safe_exit
    redirect_to '/games/menu'
  end

  def destroy
    @game = Game.find_by(params[:id])
    @objects = GameObject.where(game_id: @game.id)
    @objects.destroy_all
    @game.destroy
    redirect_to '/games/menu'
  end

  # Functional routes

  def show_field
    @game = Game.first
  end

  def move_player
    @game = Game.find_by(id: params[:id])
    event = @game.move_player(params[:direction])
    if event == "item"
      redirect_to "/games/#{@game.id}/item"
    elsif event == "fight"
      redirect_to "/games/#{@game.id}/fight"
    else
      @game.make_a_turn
      redirect_to "/games/#{@game.id}/play"
    end
  end

  def fight
    @game = Game.find_by(params[:id])
    @player = @game.game_objects.find_by(game_type: "player")
    @opponent = @game.game_objects.where.not(game_type: "player").find_by(x: @player.x, y: @player.y)
    @log = @player.attack_target(@opponent)
  end

  def next_turn
    @game = Game.find_by(id: params[:id])
    @game.make_a_turn
    redirect_to "/games/#{@game.id}/play"
  end

  # Helper Methods

  def player_stats
    @game = Game.find_by(id: params[:id])
    @game.player_stats
  end

  def game_params
    params.require(:game).permit(:board_width, :board_heigth,
                                 :initial_zombies, :initial_npc,
                                 :current_score, :is_running,
                                 :user_id)
  end

end
