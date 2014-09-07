class CreateSpotNames < ActiveRecord::Migration
  def change
    create_table :spot_names do |t|
      t.string :name, :limit => 80, :null => false

      t.timestamps
    end
    add_index :spot_names, :name, :unique => true
  end
end
