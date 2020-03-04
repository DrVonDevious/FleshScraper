class NonPlayerCharachter < ApplicationRecord
  belongs_to :cell

  def self.create_random(level=2)
    is_alive = true
    picture_url = "/app/assets/images/zombie.png"
    hp = level * 2 * 5
    attack = rand(1...level)
    defence = level * 2 - attack
    speed = 1
    range_of_sight = 10
    {is_alive: is_alive, picture_url: picture_url, hp: hp, attack: attack, defence: defence, speed: speed, range_of_sight: range_of_sight, created_at: Time.now, updated_at: Time.now}
  end
end
