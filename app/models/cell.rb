class Cell < ApplicationRecord
  belongs_to :game
  has_one :zombie
  has_one :player
  has_one :non_player_charachter
  has_one :item
  has_one :obstacle

  # def north
  #   if self.y == self.game.board_heigth
  #     return nil
  #   else
  #     return Cell.find_by(game: self.game, x: self.x, y: self.y + 1)
  #   end
  # end

  # def south
  #   if self.y == 1
  #     return nil
  #   else
  #     return Cell.find_by(game: self.game, x: self.x, y: self.y - 1)
  #   end
  # end

  # def west
  #   if self.x == 1
  #     return nil
  #   else
  #     x = self.x - 1
  #     return Cell.find_by(game: self.game, x: x, y: self.y)
  #   end
  # end

  # def west
  #   if self.x == self.game.board_width
  #     return nil
  #   else
  #     return Cell.find_by(game: self.game, x: self.x -1, y: self.y)
  #   end
  # end

  # def nearest_cells
  #   [self.north, self.south, self.east, self.west].compact
  # end


end
