class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name, null: false
      t.string :address, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.string :lat
      t.string :lon
      t.belongs_to :parking_search, index: true
      t.belongs_to :parking_venue, index: true      
      t.timestamps null: false
    end
  end
end
