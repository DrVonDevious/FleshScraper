class CreatePlayers < ActiveRecord::Migration[6.0]
  def change
    create_table :players do |t|
      t.boolean :is_alive
      t.string :picture_url
      t.integer :cell_id
      t.integer :hp
      t.integer :attack
      t.integer :defence
      t.integer :speed
      t.integer :level_points
      t.integer :range_of_sight


      t.timestamps
    end
  end
end
