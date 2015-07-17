require 'json'
require 'httparty'
require 'pry'

class ParkingSearchesController < ApplicationController
  # before_action :authenticate_user!, except: [:index, :show]

  def new
    @parking_search = ParkingSearch.new
    @parking_search.city = 'Boston'
    @parking_search.state = 'MA'
    
  end

  def create
    @parking_search = ParkingSearch.new(address: params[:address], city: 'Boston', state: 'MA')  # parking_search_params)
    @parking_search.user = current_user

    park_data = fetch_parking_venues(@parking_search)

    @parking_search.lat = park_data["lat"]
    @parking_search.lon = park_data["lng"]

    listing = fetch_top_ten_venues(park_data)
    @parking_search.save

    listing.each do |vdat| 
      @parking_venue = @parking_search.parking_venues.new(location_name: vdat['location_name'])

      # fill in parking venue from API listing
      @parking_venue.address = vdat['address']
      @parking_venue.city = vdat['city']
      @parking_venue.state = vdat['state']
      @parking_venue.zip = vdat['zip']
      @parking_venue.lat = vdat['lat']
      @parking_venue.lon = vdat['lng']
      @parking_venue.description = vdat['description']
      @parking_venue.location_id = vdat['location_id']

      @parking_venue.save

      search_venue_set = SearchVenueSet.new(parking_venue_id: @parking_venue.id, parking_search_id: @parking_search.id)
      # has parking_search_id , but no parking_venue.id -> pre save
      # fill in venue_set
      search_venue_set.price_formated =  vdat['price_formatted']
      search_venue_set.distance = vdat['distance']
      search_venue_set.available_spaces = vdat['available_spaces']
      search_venue_set.save
    end    
    #[id: @parking_search.id]
    #    <td><%= link_to "Details", dive_site_path(dive_site) %></td>
    if @parking_search.save
      flash[:notice] = 'Parking Search added.'
      redirect_to parking_search_path(@parking_search)
    else
      render :new
    end
  end

  def fetch_top_ten_venues park_data
    n_locations = park_data["locations"]
    n = n_locations > 10 ? 10 : n_locations
    i = 0
    listing = []
    while i < n
      listing << park_data['parking_listings'][i]
      i += 1
    end
    listing
  end
  
  def fetch_parking_venues search
    addr_string = Rack::Utils.escape(search.address + ',' + search.city)
    search_string = 'http://api.parkwhiz.com/search/?destination=' + addr_string + '&key=62d882d8cfe5680004fa849286b6ce20'
    response = HTTParty.get(search_string)
    response_json = JSON.parse(response.body)
  end

  def show
    @parking_search = ParkingSearch.find_by(id: params[:id])

    if @parking_search
      @parking_venues = @parking_search.parking_venues(@parking_search)
      @search_venue_sets = @parking_search.search_venue_sets(@parking_search)
    end
  end

  
=begin  
  def index
    @dive_sites = DiveSite.search(params[:search]).page params[:page]
  end


  def destroy
    @dive_site = DiveSite.find_by(id: params[:id])

    if @dive_site.user == current_user || current_user.admin?
      if @dive_site.destroy
        flash[:notice] = "Dive Site Deleted"
        redirect_to dive_sites_path
      else
        flash[:alert] = @dive_site.errors.full_messages
        render :index
      end
    else
      flash[:alert] = "You aren't allowed to do that!
      redirect_to dive_sites_path
    end
  end
=end
  
  protected

  def parking_search_params
    params.require(:parking_search).permit(
      :address
#      :city,
#      :state
    )
  end

end
