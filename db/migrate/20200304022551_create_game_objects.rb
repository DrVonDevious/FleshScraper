class CreateGameObjects < ActiveRecord::Migration[6.0]
  def change
    create_table :game_objects do |t|
      t.boolean :is_alive
      t.string :css_class
      t.integer :x
      t.integer :y
      t.string :game_type
      t.integer :hp
      t.integer :attack
      t.integer :defence
      t.integer :speed
      t.integer :level_points
      t.integer :range_of_sight
      t.boolean :destructible
      t.integer :game_id

      t.timestamps
    end
  end
end
