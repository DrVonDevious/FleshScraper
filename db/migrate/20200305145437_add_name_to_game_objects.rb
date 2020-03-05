class AddNameToGameObjects < ActiveRecord::Migration[6.0]
  def change
    add_column :game_objects, :name, :string
  end
end
