class Player < ApplicationRecord
  belongs_to :cell

  def move(direction)
    puts direction
  end

end
