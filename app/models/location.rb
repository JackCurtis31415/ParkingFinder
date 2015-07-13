class Location < ActiveRecord::Base
  belongs_to :parking_search
  belongs_to :parking_venue
  validates :name, presence: true
  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
end
