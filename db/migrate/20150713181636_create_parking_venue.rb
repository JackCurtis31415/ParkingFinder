class CreateParkingVenue < ActiveRecord::Migration
  def change
    create_table :parking_venues do |t|
      t.string :location_name, null: false
      t.string :address, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.string :zip
      t.string :timezone
      t.float :lat,  null: false
      t.float :lon,  null: false
      t.text   :description
      t.integer :location_id
      t.timestamps
    end
  end
end
