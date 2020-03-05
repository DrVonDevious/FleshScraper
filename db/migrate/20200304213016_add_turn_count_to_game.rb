class AddTurnCountToGame < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :turn_count, :integer
  end
end
