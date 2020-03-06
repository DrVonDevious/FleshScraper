class Game < ApplicationRecord

  belongs_to :user
  has_many :game_objects

  def generate(heroname = "Arthur")
    self.update(board_width: 100, board_heigth: 100, initial_zombies: 101, initial_npc: 10, turn_count: 0, current_score: 0)
    # generate player
    player = GameObject.generate_player(self)
    player.update(name: heroname)
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
    player = self.game_objects.find_by(game_type: "player")
    player.move_player(direction)
  end

  def player_stats
    player = self.game_objects.find_by(game_type: "player")
    stats = { hp: player.hp,
              attack: player.attack,
              defence: player.defence,
              speed: player.speed,
              name: player.name,
              score: self.current_score,
              turns: self.turn_count }
  end

  def mobs
    self.game_objects.where(game_type: ["zombie", "npc"])
  end

  def make_a_turn
    self.update(turn_count: self.turn_count + 1)
    self.update_score(1)
    self.mobs.each { |mob|
      mob.make_a_move
    }
  end

  def update_score(amount)
    self.update(current_score: self.current_score + amount)
  end

end
