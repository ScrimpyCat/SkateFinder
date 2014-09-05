class CreateObstacleNames < ActiveRecord::Migration
  def change
    create_table :obstacle_names do |t|
      t.string :name, limit: 25

      t.timestamps
    end
    add_index :obstacle_names, :name, unique: true
  end
end
