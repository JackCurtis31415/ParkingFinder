class ParkingSearch < ActiveRecord::Base
  belongs_to :user
  has_many :search_venue_sets
  has_many :parking_venues, :through => :search_venue_sets
  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
end
