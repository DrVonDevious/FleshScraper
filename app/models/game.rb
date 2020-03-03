class Game < ApplicationRecord
  belongs_to :user
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
      (1...self.board_heigth).each { |y|
        Cell.create(x: x, y: y, picture_url: "/app/assets/images/grass.png")
      }
    }
    # generate the obstacles
    # (self.board_width * 3).times do
    #   x = (1..self.board_width)
    #   y = (1..self.board_heigth)
    #   cell = Cell.find_by(game: self, x: x, y: y)
    #   o = Obstacle.new(cell: cell, picture_url: "/app/assets/images/obstacle.png")
    #   if !o.is_hinder?
    #     o.save
    #   end
    # end

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
end
