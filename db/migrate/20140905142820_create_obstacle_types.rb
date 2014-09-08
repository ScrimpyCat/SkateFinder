class CreateObstacleTypes < ActiveRecord::Migration
	def change
		create_table :obstacle_types do |t|
			t.string :name, :limit => 25, :null => false

			t.timestamps
		end
		add_index :obstacle_types, :name, :unique => true
	end
end
