class CreateParkingSearches < ActiveRecord::Migration
  def change
    create_table :parking_searches do |t|
      t.string :location_address           # strong represention of street address
      t.belongs_to :user, index: true
      t.datetime :time_start, null: false
      t.datetime :time_end, null: false      
      t.timestamps null: false
    end
  end
end
