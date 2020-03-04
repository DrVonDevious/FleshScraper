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

  def make_a_move
    position = {x: self.cell.x, y: self.cell.y}
    line_of_sight = self.cell.game.cells.where(x: position[:x]-range_of_sight...position[:x]+range_of_sight, y: position[:y]-range_of_sight...position[:y]+range_of_sight)

    # if NonPlayerCharachter.where(:cell => line_of_sight).count > 0 && Player.where(:cell => line_of_sight).count > 0

    # else
      self.update(cell: self.cell.nearest_free_cells.sample)
    # end

  end

  def print
    div_open = "<div id= \"#{self.css_class}\" style = \"grid-column-start: #{self.x}; grid-column-end: #{self.x}; grid-row-start: #{self.y}; grid-row-end: #{self.y}\">".html_safe
    div_close = "</div>".html_safe
    "#{div_open} #{div_close}"
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
      self.update(y: self.y + 1, x: self.x + 1)
    end
  end

end
