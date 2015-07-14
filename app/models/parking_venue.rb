class ParkingVenue < ActiveRecord::Base
  has_many :parking_searches
  has_many :parking_searches, :through => :search_venue_set

  validates :location_name, presence: true
  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :lat, presence: true
  validates :lon, presence: true
end
