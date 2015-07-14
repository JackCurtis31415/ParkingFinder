class SearchVenueSet < ActiveRecord::Base
  belongs_to :parking_venue
  belongs_to :parking_search
end
