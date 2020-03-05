class AddWeaponArmorToGameObject < ActiveRecord::Migration[6.0]
  def change
    add_column :game_objects, :weapon, :string
    add_column :game_objects, :armor, :string
  end
end
