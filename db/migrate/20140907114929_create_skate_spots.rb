class CreateSkateSpots < ActiveRecord::Migration
    def change
        create_table :skate_spots do |t|
            t.decimal :longitude
            t.decimal :latitude
            t.string :geometry, :null => false
            t.references :name, :index => true
            t.boolean :park
            t.integer :style
            t.boolean :undercover
            t.integer :cost
            t.string :currency, :limit => 3
            t.boolean :lights
            t.boolean :private_property

            t.timestamps
        end
    end
end
