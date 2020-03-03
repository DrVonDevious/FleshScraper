class Game < ApplicationRecord
  belongs_to :user
  has_many :cells
  has_many :zombies, through: :cells
  has_many :players, through: :cells
  has_many :non_player_charachters, through: :cells
  has_many :items, through: :cells
  has_many :obstacles, through: :cells

 
  def generate
    self.update(board_width: 100, board_heigth: 100, initial_zombies: 100, initial_npc: 10)
    # generate the board
    cells = []
    (0...self.board_width).each { |x|
      
      (0...self.board_heigth).each { |y|
        cells << {game_id: self.id, x: x, y: y, picture_url: "/app/assets/images/grass.png", created_at: Time.now, updated_at: Time.now}
      }
      
    }

    Cell.insert_all(cells)

    # generate player

    # generate the obstacles
    obstacles = []
    all_cells = self.cells
    (self.board_width * 3).times do
      cell = all_cells.sample
      obstacles << {cell_id: cell.id, picture_url: "/app/assets/images/obstacle.png", created_at: Time.now, updated_at: Time.now}
      # if !o.is_hinder?
      #   o.save
      # end
    end

    Obstacle.insert_all(obstacles)


    # generate the zombies

    zombies = []
    while zombies.length < self.initial_zombies do
      cell = all_cells.sample
      if !cell.obstacle
        z = Zombie.create_random
        z[:cell_id] = cell.id
        zombies << z
      end
    end
    
    Zombie.insert_all(zombies)



    # generate the NPC

    npc = []
    while npc.length < self.initial_npc do
      cell = all_cells.sample
      if !cell.obstacle && !cell.zombie
        z = NonPlayerCharachter.create_random
        z[:cell_id] = cell.id
        npc << z
      end
    end
    
    NonPlayerCharachter.insert_all(npc)

    # generate the crates



  end

  def find_cell(x,y)
    Cell.find_by(game: self, x: x, y: y)
  end

  def game_field
    # t = Time.now
    temp = {}
    self.cells.each{ |cell|
      if !temp[cell.x]
        temp[cell.x] = {}
      end
      if !temp[cell.x][cell.y]
        temp[cell.x][cell.y] = {}
      end
      temp[cell.x][cell.y][:cell] = cell
    }
    self.obstacles.each{ |obstacle|
      temp[obstacle.cell.x][obstacle.cell.y][:obstacle] = obstacle
    }
    self.zombies.each{ |zombie|
    temp[zombie.cell.x][zombie.cell.y][:zombie] = zombie
    }
    self.non_player_charachters.each{ |npc|
      temp[npc.cell.x][npc.cell.y][:npc] = npc
    }
    # a = Time.now - t
    # a
    temp
  end


  def print
    my_cells = self.game_field
    result = ""
    my_cells.each { |x, row|
      row.each { |y, hash| 
        result += Cell.print(hash, x, y)
      }
    }
    result.html_safe
  end
end
