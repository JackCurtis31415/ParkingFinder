class ParkingSearch < ActiveRecord::Base
  belongs_to :user
  has_many :search_venue_sets
  has_many :parking_venues, :through => :search_venue_sets
  validates :time_start, presence: true
  validates :time_end, presence: true
end
