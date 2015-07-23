require 'json'
require 'httparty'

class ParkingSearchesController < ApplicationController
  # before_action :authenticate_user!, except: [:index, :show]

  def new
    if !params[:city].nil?
      @city = params[:city]
      case @city
      when 'Boston'
        @state = 'MA'
      when 'New York'
        @state = 'NY'
      when 'Chicago'
        @state = 'IL'
      when 'San Francisco'
        @state = 'CA'
      else
        flash[:alert] = "City select error occured!"
      end
    else
      @city = 'Boston'
      @state = 'MA'
    end

    @parking_search = ParkingSearch.new
    @parking_search.city = @city
    @parking_search.state = @state
    
  end

  def create

    puts "create: top"
    # @lat_lng = cookies[:lat_lng].split("|")

    @parking_search = ParkingSearch.new(address: params[:address], city: params[:city], state: params[:state])  # parking_search_params)

    puts "create: post parking_search.new"
    @parking_search.user = current_user

    puts "create: pre fetch_parking_venues"
    park_data = fetch_parking_venues(@parking_search)

    puts "create: post fetch_parking_venues"
    @parking_search.lat = park_data["lat"]
    @parking_search.lon = park_data["lng"]

    puts "create: pre fetch_top_ten"
    listing = fetch_top_ten_venues(park_data)

    puts "create: pre .save"
    @parking_search.save

    puts "create: post .save"
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

    search_string = 'http://api.parkwhiz.com/search/?destination=' + addr_string + '&key=' + "#{ENV['PARKING_WHIZ_KEY']}"
    response = HTTParty.get(search_string)
    response_json = JSON.parse(response.body)
  end
  
  def show
    @parking_search = ParkingSearch.find_by(id: params[:id])

    if @parking_search
      @parking_venues = @parking_search.parking_venues(@parking_search)
      @search_venue_sets = @parking_search.search_venue_sets(@parking_search)
    end

    @by_price = []
    
    @parking_venues.each_with_index do |venue, i| 
      @by_price << [@search_venue_sets[i].price_formated.gsub(/\$/, '').to_i, i]
    end

    @price_category = []

    @by_price.sort!.each_with_index do |entry, i|
      @price_category << [ entry[1], 'low'] if i  <= (@by_price.length / 3)
      @price_category << [ entry[1], 'med'] if i > (@by_price.length / 3) && i <= 2 * (@by_price.length / 3)
      @price_category << [ entry[1], 'high'] if i > 2 * (@by_price.length / 3)
    end

    @price_category.sort!
  end
  
  protected

  def parking_search_params

    params.require(:parking_search).permit(
      :address,
      :city
#      :state
    )
    params.permit(:city)
  end

end
