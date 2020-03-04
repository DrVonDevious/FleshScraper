class GameObject < ApplicationRecord
  belongs_to :game



  # t.boolean :is_alive
  # t.string :css_class
  # t.integer :x
  # t.integer :y
  # t.string :type
  # t.integer :hp
  # t.integer :attack
  # t.integer :defence
  # t.integer :speed
  # t.integer :level_points
  # t.integer :range_of_sight
  # t.boolean :destructible
  # t.integer :game_id

  def self.generate_player(game)
    game_type = "player"
    css_class = "player"
    y = 50
    x = 50

    hash = {x: x, y: y, game_id: game.id, is_alive: true,
            css_class: css_class, game_type: game_type,
            created_at: Time.now, updated_at: Time.now}

    hp = 20
    attack = 3
    defence = 3
    speed = 1
    range_of_sight = 5

    hash.merge(hp: hp, attack: attack, defence: defence,
               speed: speed, range_of_sight: range_of_sight)
  end

  def self.create_random(game, type, level=2)
    is_alive = true
    game_type = type
    css_class = type
    x = rand(1..game.board_width)
    y = rand(1..game.board_heigth)
    hash = {x: x, y: y, game_id: game.id, is_alive: is_alive, css_class: css_class, game_type: type, created_at: Time.now, updated_at: Time.now}
    if type == "zombie" || type == "player" || type = "npc"
      hp = level * 2 * 3
      range_of_sight = 5
      attack = rand(1...level)
      defence = level * 2 - attack
      speed = 1
      if type != "zombie"
        hp *= 2
        range_of_sight *= 2
      end
      hash.merge(hp: hp, attack: attack, defence: defence, speed: speed, range_of_sight: range_of_sight)
    end

  end

  def nearest_free_cells
    possible_moves = [[-1,1],[-1,0],[-1,-1],[0,-1],[1,-1],[1,0],[1,1],[0,1]]
    objects_nearby = self.game.game_objects.where(x: (self.x-1..self.x+1).to_a, y: (self.y-1..self.y+1).to_a) - [self]
    objects_nearby.each{ |object|
      possible_moves -= [[object.x - self.x, object.y - self.y]]
    }
    if self.x == 0
      possible_moves -= [[-1,1],[-1,0],[-1,-1]]
    end
    if self.x == self.game.board_width
      possible_moves -= [[1,-1],[1,0],[1,1]]
    end
    if self.y == 0
      possible_moves -= [[-1,-1],[0,-1],[1,-1]]
    end
    if self.y == self.game.board_heigth
      possible_moves -= [[-1,1],[1,1],[0,1]]
    end
    possible_moves
  end

  def move(x,y)
    self.update(x: self.x + x, y: self.y + y)
  end

  def make_a_move
    if self.targets_in_sight.count > 0 
      chosen = direction_to_nearest
    else
      chosen = self.nearest_free_cells.sample
    end
    if chosen 
      self.move(chosen[0], chosen[1])
    end
  end

  def targets_in_sight
    hunting_types  = ["zombie", "player", "npc"] - [self.game_type]
    self.game.game_objects.where(game_type: hunting_types,x: (self.x-self.range_of_sight..self.x+self.range_of_sight).to_a, y: (self.y-self.range_of_sight..self.y+self.range_of_sight).to_a) - [self]
  end

  def cells_in_sight(distance)
  end

  def nearest_target
    targets_in_sight.min_by { |target|
      Math.sqrt((target.x - self.x)**2+(target.y - self.y)**2)
    }
  end

  def direction_to_nearest
    self.nearest_free_cells.min_by { |coordinates|
      distance_to_target(self.x + coordinates[0], self.y + coordinates[1], self.nearest_target.x, self.nearest_target.y)
    }
  end

  def distance_to_target(start_x, start_y, target_x, target_y)
    Math.sqrt((target_x - start_x)**2+(target_y- start_y)**2)
  end

  def print
    div_open = "<div id= \"#{self.css_class}\" style = \"grid-column-start: #{self.x}; grid-row-start: #{self.y};\">".html_safe
    div_close = "</div>".html_safe
    "#{div_open}#{self.x}:#{self.y}#{div_close}"
  end


  def attack(object)
  end


  # Player Commands
  def move_player(direction)
    case direction
    when "northeast"
      self.update(y: self.y - 1, x: self.x + 1) if collision?([+1, -1])
    when "north"
      self.update(y: self.y - 1) if collision?([0, -1])
    when "northwest"
      self.update(y: self.y - 1, x: self.x - 1) if collision?([-1, -1])
    when "east"
      self.update(x: self.x + 1) if collision?([+1, 0])
    when "west"
      self.update(x: self.x - 1) if collision?([-1, 0])
    when "southeast"
      self.update(y: self.y + 1, x: self.x + 1) if collision?([+1, +1])
    when "south"
      self.update(y: self.y + 1) if collision?([0, +1])
    when "southwest"
      self.update(y: self.y + 1, x: self.x - 1) if collision?([-1, +1])
    end
  end

  private

  def collision?(coords)
    nearest_free_cells.include?(coords)
  end

end

