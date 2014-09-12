class CreateSpotNames < ActiveRecord::Migration
    def change
        create_table :spot_names do |t|
            t.string :name, :limit => 80, :null => false
            t.references :spot, :index => true, :null => false

            t.timestamps
        end
    end
end
