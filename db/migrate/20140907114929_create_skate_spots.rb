class CreateSkateSpots < ActiveRecord::Migration
  def change
    create_table :skate_spots do |t|
      t.decimal :longitude
      t.decimal :latitude
      t.string :geometry
      t.references :name, :index => true
      # t.references :alt_names, :index => true
      t.integer :type
      t.integer :style
      t.boolean :undercover
      t.integer :cost
      t.string :currency, :limit => 3
      t.boolean :lights
      t.boolean :private_property
      # t.references :obstacles, :index => true

      t.timestamps
    end
  end
end
