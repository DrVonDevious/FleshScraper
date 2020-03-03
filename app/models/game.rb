class Game < ApplicationRecord
  # belongs_to :user
  has_many :cells
  has_many :zombies, through: :cells
  has_many :players, through: :cells
  has_many :non_player_charachters, through: :cells
  has_many :items, through: :cells
  has_many :obstacles, through: :cells


  def generate
    self.update(board_width: 100, board_heigth: 100, initial_zombies: 10, initial_npc: 5)
    # generate the board
    (1...self.board_width).each { |x|
      cells = []
      (1...self.board_heigth).each { |y|
        cells << {game_id: self.id, x: x, y: y, picture_url: "/app/assets/images/grass.png", created_at: Time.now, updated_at: Time.now}
      }
      Cell.insert_all(cells)
    }
    # generate the obstacles

  
    obstacles = []
    (self.board_width * 3).times do
      x = (1..self.board_width)
      y = (1..self.board_heigth)
      cell = Cell.find_by(game: self, x: x, y: y)
      obstacles << {cell_id: cell.id, picture_url: "/app/assets/images/obstacle.png", created_at: Time.now, updated_at: Time.now}
      # if !o.is_hinder?
      #   o.save
      # end
    end

    Obstacle.insert_all(obstacles)


    # generate the zombies
    # self.initial_zombies.times do
    #   zombie = Zombie.create_random
    #   loop do
    #     x = rand(1..self.board_width)
    #     y = rand(1..self.board_heigth)
    #     cell = Cell.find_by(game: self, x: x, y: y)
    #     break if cell.zombie == nil && cell.obstacle == nil
    #   end
    #   zombie.cell = cell
    #   zombie.save
    # end


    # generate the NPC


    # generate the crates



  end

  def find_cell(x,y)
    Cell.find_by(game: self, x: x, y: y)
  end


  def print
    result = ""
    (1...self.board_width).each { |x|
      (1...self.board_heigth).each { |y|
        result += self.find_cell(x,y).print
      }
    }
    result
  end
end
