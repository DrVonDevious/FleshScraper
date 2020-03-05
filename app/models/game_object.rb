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
    if type == "zombie" || type == "player" || type == "npc"
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
    if targets_in_attack_range.count > 0
      target = self.nearest_target
      if target.game_type = "item"
        self.update(x: target.x, y: target.y)
        self.open_the_crate(target)
      else
        self.attack_target(target)
      end
    else
      chosen_direction = direction_to_nearest
    end
  else
    chosen_direction  = self.nearest_free_cells.sample
  end
  if chosen_direction
    self.move(chosen_direction [0], chosen_direction [1])
  end
end

def open_the_crate(target)
  target.destroy
  current_item = GameObject.get_item_by_name(item_name)
  new_item = GameObject.random_item
  if current_item

  else

  end
end

def wear_item(item)
  self.attack += item[:attack]
  self.defence += item[:defence]
  self.hp += item[:hp]
  self.save
end

def unwear_item(item)
  self.attack -= item[:attack]
  self.defence -= item[:defence]
  self.hp -= item[:hp]
  self.save
end



def targets_in_sight
  hunting_types  = ["zombie", "player", "npc", "crate"] - [self.game_type]
  self.game.game_objects.where(game_type: hunting_types,x: (self.x-self.range_of_sight..self.x+self.range_of_sight).to_a, y: (self.y-self.range_of_sight..self.y+self.range_of_sight).to_a) - [self]
end

def targets_in_attack_range
  hunting_types  = ["zombie", "player", "npc", "crate"] - [self.game_type]
  self.game.game_objects.where(game_type: hunting_types,x: (self.x-1..self.x+1).to_a, y: (self.y-1..self.y+1).to_a) - [self]
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
  div_open = "<div id= \"#{self.css_class}\" style = \"grid-column-start: #{self.x}; grid-column-end: #{self.x}; grid-row-start: #{self.y}; grid-row-end: #{self.y}\">".html_safe
  div_close = "</div>".html_safe
  "#{div_open}#{self.x}:#{self.y}#{div_close}"
end

def attack_target(object)
  while object.is_alive && self.is_alive
    hit = rand(0..self.attack)
    if hit == self.attack
      object.hp -= hit*2
    else
      object.hp -= hit - [rand(0..object.defence), hit].min  
    end
    if object.hp < 0 
      object.is_alive = false
      object.game_type = "item"
      object.css_class = "item"
      if self.game_type == "player"
        self.level_points += 3
      else
        self.attack += 1
        self.defence += 1
        self.hp += 1
      end
    end
    hit = rand(0..object.attack)
    if hit == object.attack
      self.hp -= hit*2
    else
      self.hp -= hit - [rand(0..self.defence), hit].min  
    end
    if self.hp < 0 
      self.is_alive = false
      self.game_type = "item"
      self.css_class = "item"
      object.attack += 1
      object.defence += 1
      object.hp += 1
    end
    self.save
    object.save
  end

end



  # Player Commands
  def move_player(direction)
    case direction
    when "northeast"
      self.update(y: self.y - 1, x: self.x - 1)
    when "north"
      self.update(y: self.y - 1)
    when "northwest"
      self.update(y: self.y - 1, x: self.x + 1)
    when "east"
      self.update(x: self.x + 1)
    when "west"
      self.update(x: self.x - 1)
    when "southeast"
      self.update(y: self.y + 1, x: self.x - 1)
    when "south"
      self.update(y: self.y + 1)
    when "southwest"
      self.update(y: self.y + 1, x: self.x + 1) if collision?()
    end
  end

  private

  def collision?(x, y)
  end

  def self.get_item_level(item_name)
    GameObject.item_list.find{|item| item[:name] == item_name}[:level] rescue 0
  end

  def self.get_item_by_name(item_name)
    GameObject.item_list.find{|item| item[:name] == item_name}
  end

  def self.random_item
    list = []
    3.times do
      list << item_list.sample
    end
    list.min_by {|item| item[:level]}
  end

  def self.item_list
    [
      {
        name: "Big, Red, Delicious Apple",
        type: "medical",
        level: 1,
        attack: 0,
        defence: 0,
        hp: 5
      },
      {
        name: "Chipotle Bowl from Chipotle on Main",
        type: "medical",
        level: 2,
        attack: 0,
        defence: 0,
        hp: 10
      },
      {
        name: "Something Asian from tunnels",
        type: "medical",
        level: 3,
        attack: 0,
        defence: 0,
        hp: 15
      },
      {
        name: "Grandma pie (I don't how it gets here)",
        type: "medical",
        level: 4,
        attack: 0,
        defence: 0,
        hp: 20
      },
      {
        name: "Big Rib-eye steak",
        type: "medical",
        level: 5,
        attack: 0,
        defence: 0,
        hp: 25
      },
      {
        name: "Small Medical Kit",
        type: "medical",
        level: 6,
        attack: 0,
        defence: 0,
        hp: 30
      },
      {
        name: "Medical Kit Medium Size",
        type: "medical",
        level: 7,
        attack: 0,
        defence: 0,
        hp: 35
      },
      {
        name: "Medical Kit Medium Size with extra morphine",
        type: "medical",
        level: 8,
        attack: 0,
        defence: 0,
        hp: 40
      },
      {
        name: "Large Medical Kit with spare organs",
        type: "medical",
        level: 9,
        attack: 0,
        defence: 0,
        hp: 45
      },
      {
        name: "Enormously Large Medical Kit With Possibility to install bionical parts",
        type: "medical",
        level: 10,
        attack: 10,
        defence: 10,
        hp: 50
      },
      {
        name: "Super Soaker with Holy Water",
        type: "weapon",
        level: 1,
        attack: 5,
        defence: 0,
        hp: 0
      },
      {
        name: "Prison Shank",
        type: "weapon",
        level: 2,
        attack: 10,
        defence: 0,
        hp: 0
      },
      {
        name: "Baseball Bat",
        type: "weapon",
        level: 3,
        attack: 15,
        defence: 0,
        hp: 0
      },
      {
        name: "Knight Sword",
        type: "weapon",
        level: 4,
        attack: 20,
        defence: 0,
        hp: 0
      },
      {
        name: "Pistol",
        type: "weapon",
        level: 5,
        attack: 25,
        defence: 0,
        hp: 0
      },
      {
        name: "Shotgun",
        type: "weapon",
        level: 6,
        attack: 30,
        defence: 0,
        hp: 0
      },
      {
        name: "Uzi",
        type: "weapon",
        level: 7,
        attack: 35,
        defence: 0,
        hp: 0
      },
      {
        name: "AK-47 (Чо каво, сучары?)",
        type: "weapon",
        level: 8,
        attack: 40,
        defence: 0,
        hp: 0
      },
      {
        name: "Rocket Launcher",
        type: "weapon",
        level: 9,
        attack: 45,
        defence: 0,
        hp: 0
      },
      {
        name: "Alien Plasma Gun",
        type: "weapon",
        level: 10,
        attack: 60,
        defence: 0,
        hp: 0
      },
      {
        name: "Large piece of corrugated board",
        type: "armor",
        level: 1,
        attack: 0,
        defence: 5,
        hp: 0
      },
      {
        name: "Old barn door",
        type: "armor",
        level: 2,
        attack: 0,
        defence: 10,
        hp: 0
      },
      {
        name: "Clown costume",
        type: "armor",
        level: 3,
        attack: 0,
        defence: 15,
        hp: 0
      },
      {
        name: "Dog trainer uniform",
        type: "armor",
        level: 4,
        attack: 0,
        defence: 20,
        hp: 0
      },
      {
        name: "Coen brothers Pan costume",
        type: "armor",
        level: 5,
        attack: 0,
        defence: 25,
        hp: 0
      },
      {
        name: "Glamour dress (distracts the enemy)",
        type: "armor",
        level: 6,
        attack: 0,
        defence: 30,
        hp: 0
      },
      {
        name: "Russian army \"РХБЗ\" costume",
        type: "armor",
        level: 7,
        attack: 0,
        defence: 35,
        hp: 0
      },
      {
        name: "Bulletproof Vest",
        type: "armor",
        level: 8,
        attack: 0,
        defence: 40,
        hp: 0
      },
      {
        name: "Full knight armor",
        type: "armor",
        level: 9,
        attack: 0,
        defence: 45,
        hp: 0
      },
      {
        name: "Alien Battle Armor",
        type: "armor",
        level: 10,
        attack: 0,
        defence: 50,
        hp: 0
      },
    ]
  end

end