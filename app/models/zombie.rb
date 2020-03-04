class Zombie < ApplicationRecord
  belongs_to :cell
  belongs_to :game

  def self.create_random(level=2)
    is_alive = true
    picture_url = "/app/assets/images/zombie.png"
    hp = level * 2 * 3
    attack = rand(1...level)
    defence = level * 2 - attack
    speed = 1
    range_of_sight = 5
    {is_alive: is_alive, picture_url: picture_url, hp: hp, attack: attack, defence: defence, speed: speed, range_of_sight: range_of_sight, created_at: Time.now, updated_at: Time.now}
  end

  def make_a_move
    position = {x: self.cell.x, y: self.cell.y}
    line_of_sight = self.cell.game.cells.where(x: position[:x]-range_of_sight...position[:x]+range_of_sight, y: position[:y]-range_of_sight...position[:y]+range_of_sight)

    # if NonPlayerCharachter.where(:cell => line_of_sight).count > 0 && Player.where(:cell => line_of_sight).count > 0

    # else
      self.update(cell: self.cell.nearest_free_cells.sample)
    # end

  end
end

