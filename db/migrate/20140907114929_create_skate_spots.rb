class CreateSkateSpots < ActiveRecord::Migration
    def change
        create_table :skate_spots do |t|
            t.decimal :longitude
            t.decimal :latitude
            t.string :geometry
            t.references :name, :index => true
            t.integer :kind
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