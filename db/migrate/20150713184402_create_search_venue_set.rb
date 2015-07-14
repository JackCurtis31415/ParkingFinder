class CreateSearchVenueSet < ActiveRecord::Migration
  def change
    create_table :search_venue_sets do |t|
      t.belongs_to :parking_venue, index: true
      t.belongs_to :parking_search, index: true
      t.string :price_formated
      t.integer :distance
      t.string :available_spaces   # note:volatile
      t.timestamps null: false
    end
  end
end
