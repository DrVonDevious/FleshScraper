class Game < ApplicationRecord
  # belongs_to :user
  has_many :cells
  has_many :zombies, through: :cells
  has_many :players, through: :cells
  has_many :non_player_charachters, through: :cells
  has_many :items, through: :cells
  has_many :obstacles, through: :cells
  has_many :game_objects

 
  def generate(heroname = "Arthur")
    self.update(board_width: 100, board_heigth: 100, initial_zombies: 100, initial_npc: 10)
    # generate player
    player = GameObject.generate_player(self)
    GameObject.insert(player)
    object_array = []
    (self.board_width * 3).times do
      object_array << GameObject.create_random(self, "obstacle")
    end
    self.board_width.times do
      object_array << GameObject.create_random(self, "item")
    end
    GameObject.insert_all(object_array)
    object_array = []
    self.initial_zombies.times do 
      object_array << GameObject.create_random(self, "zombie")
    end
    self.initial_npc.times do 
      object_array << GameObject.create_random(self, "npc")
    end
 
    GameObject.insert_all(object_array)
  end


  def print
    all_stuff = self.game_objects.order(x: :asc, y: :asc)
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



  def mobs
    self.game_objects.where(game_type: ["zombie", "npc"])
  end

  def make_a_turn
    self.mobs.each { |mob|
      mob.make_a_move
    }
  end
end
