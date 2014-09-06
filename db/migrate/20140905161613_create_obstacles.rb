class CreateObstacles < ActiveRecord::Migration
  def change
    create_table :obstacles do |t|
      t.references :type, :index => true, :null => false
      t.string :geometry

      t.timestamps
    end
  end
end
