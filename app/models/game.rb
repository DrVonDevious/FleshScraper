class Game < ApplicationRecord
  # belongs_to :user
  has_many :cells
  has_many :zombies, through: :cells
  has_many :players, through: :cells
  has_many :non_player_charachters, through: :cells
  has_many :items, through: :cells
  has_many :obstacles, through: :cells
  has_many :game_objects

 
  def generate(heroname)
    self.update(board_width: 100, board_heigth: 100, initial_zombies: 100, initial_npc: 10)

    # generate player
    player = GameObject.generate_player(self)
    GameObject.insert(player)

    # generate obstacles
    obstacles = []

    (self.board_width * 3).times do

      obstacles << GameObject.create_random(self, "obstacle")

    end

    GameObject.insert_all(obstacles)


    # generate the zombies

    zombies = []
    while zombies.length < self.initial_zombies do

      zombies << GameObject.create_random(self, "zombie")

    end

    GameObject.insert_all(zombies)

  end


  def print
    all_stuff = self.game_objects
    result = ""
    all_stuff.each { |game_object|
       result += game_object.print
    }
    result.html_safe
  end

  def move_player(direction)
    player = self.game_objects.find { |obj| obj.game_type == "player" }
    player.move_player(direction)
  end

  def make_a_turn
    self.zombies.each { |zombie|
      zombie.make_a_move
    }
  end
end
