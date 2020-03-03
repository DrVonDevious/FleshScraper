class CreateCells < ActiveRecord::Migration[6.0]
  def change
    create_table :cells do |t|
      t.integer :x
      t.integer :y
      t.string :picture_url
      t.integer :game_id

      t.timestamps
    end
  end
end
