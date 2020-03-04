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

  def nearest_cells
    self.game.cells.where(x: (self.x-1)...(self.x+2), y: (self.y-1)...(self.y+2))   # SELECT COUNT(*) FROM "cells" WHERE "cells"."game_id" = ? AND "cells"."x" >= ? AND "cells"."x" < ? AND "cells"."y" >= ? AND "cells"."y" < ? 
  end

  def nearest_free_cells
    nearest_cells.select{ |cell|
      !cell.obstacle && !cell.zombie && !cell.non_player_charachter && !cell.item && !cell.player && cell != self
    }
  end

  def self.print(hash,x,y)
    div_open = "<div id= \"cell\" style = \"grid-column-start: #{x}; grid-column-end: #{x}; grid-row-start: #{y}; grid-row-end: #{y}\">".html_safe
    if hash[:obstacle]
      content = "<div id= \"obstacle\"></div>".html_safe
    elsif hash[:zombie]
      content = "<div id= \"zombie\"></div>".html_safe
    elsif hash[:npc]
      content = "<div id= \"npc\"></div>".html_safe
    else
      content = ""
    end
    div_close = "</div>".html_safe
    "#{div_open} #{content} #{div_close}"
  end

end
