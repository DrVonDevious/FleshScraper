class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.integer :board_width
      t.integer :board_heigth
      t.integer :initial_zombies
      t.integer :initial_npc
      t.integer :current_score
      t.boolean :is_running
      t.integer :user_id
      t.timestamps
    end
  end
end
