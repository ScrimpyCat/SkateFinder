class CreateAltNames < ActiveRecord::Migration
  def change
    create_table :alt_names do |t|
      t.references :spot, :index => true, :null => false
      t.references :name, :index => true, :null => false

      t.timestamps
    end

    add_index :alt_names, [:spot_id, :name_id], :unique => true
  end
end
