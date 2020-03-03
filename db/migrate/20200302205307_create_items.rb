class CreateItems < ActiveRecord::Migration[6.0]
  def change
    create_table :items do |t|
      t.string :name
      t.string :picture_url
      t.string :type
      t.boolean :weared
      t.integer :level
      t.string :description
      t.integer :cell_id
      t.timestamps
    end
  end
end
