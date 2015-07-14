class SavedPlace < ActiveRecord::Base
  has_one :location
end
