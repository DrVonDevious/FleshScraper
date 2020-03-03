class CreateObstacles < ActiveRecord::Migration[6.0]
  def change
    create_table :obstacles do |t|
      t.string :picture_url
      t.boolean :destruclable
      t.integer :hp
      t.integer :cell_id

      t.timestamps
    end
  end
end
