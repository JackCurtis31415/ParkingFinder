class CreateParkingSearches < ActiveRecord::Migration
  def change
    create_table :parking_searches do |t|
      t.string :address, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.string :zip
      t.string :timezone
      t.float  :lat
      t.float  :lon
      t.belongs_to :user, index: true
      t.timestamps null: false
    end
  end
end
