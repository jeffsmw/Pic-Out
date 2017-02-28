require 'FuzzyStringMatch'

class HomeController < ApplicationController
  def index
    # id = 1001652496
    # @str = Nokogiri::HTML(open("https://www.instagram.com/explore/locations/#{id}")).to_s
    # a = @str.index('nodes')
    # b = @str[a..-1]
    # z = b.index(']')
    # @response = b[8..z]
    # parsed_response = ActiveSupport::JSON.decode(response)
  end

  # search
  def create
    # search = params[:search]
    lat = params[:lat]
    lng = params[:lng]
    search = lat.to_s + lng.to_s

    if Search.find_by(search: search).nil?
      @search = Search.create(search: search)
      @search.save

      get_zomato_api(lat, lng)

      # head :no_content
    else
      @search = Search.find_by(search: search)
      @results = Result.where(search_id: @search.id).order('RANDOM()').limit(60)
      respond_to do |format|
        format.js { render :search }
        format.html { render :index }
      end

    end
  end

  ## Get Zomato API for nearby restaurants ##
  def get_zomato_api(lat, lng)
    zomato_data = ''
    zomato_response = RestClient.post(
      "https://developers.zomato.com/api/v2.1/search?count=20&lat=#{lat}&lon=#{lng}",
      { 'data' => zomato_data }.to_json,
      content_type: :json, accept: :json, 'user-key': ENV['ZOMATO_ACCESS_TOKEN']
    )
    parsed_zomato = ActiveSupport::JSON.decode(zomato_response)

    # parsed_response['restaurants'][0]['restaurant']['id']
    ## Get each restaurant's name and coordinates ##
    parsed_zomato['restaurants'].each do |restaurant|
      zm_name = restaurant['restaurant']['name']
      zm_id = restaurant['restaurant']['R']['res_id']
      zm_lat = restaurant['restaurant']['location']['latitude']
      zm_lng = restaurant['restaurant']['location']['longitude']
      if Restaurant.find_by(zm_id: zm_id).nil?
        zm_url = restaurant['restaurant']['url']
        zm_cuisine = restaurant['restaurant']['cuisines']
        zm_price = restaurant['restaurant']['average_cost_for_two']
        zm_address = restaurant['restaurant']['location']['address']
        @restaurant = Restaurant.create(zm_id: zm_id,
                                        name: zm_name,
                                        url: zm_url,
                                        cuisine: zm_cuisine,
                                        price: zm_price,
                                        address: zm_address,
                                        latitude: zm_lat,
                                        longitude: zm_lng)
        @restaurant.save
      else
        @restaurant = Restaurant.find_by(zm_id: zm_id)
      end
      puts @restaurant.id
      puts '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
      get_instagram_api(zm_name, zm_lat, zm_lng)
    end
  end

  ## Get Instagram locations near coordinates  ##
  def get_instagram_api(name, lat, lng)
    url = "https://api.instagram.com/v1/locations/search?lat=#{lat}&lng=#{lng}&access_token=#{ENV['INSTAGRAM_ACCESS_TOKEN']}"
    response = RestClient.get(url)
    parsed_response = ActiveSupport::JSON.decode(response)

    parsed_response['data'].each do |restaurant|
      jarow = FuzzyStringMatch::JaroWinkler.create(:native)
      match = jarow.getDistance(name, restaurant['name'])

      if match > 0.75
        puts match
        puts restaurant['name']
        break if restaurant['id'] == '0'
        # ActionCable.server.broadcast('loading_channel',
        #                               {message: restaurant['name']})
        get_instagram_images(restaurant['id'])
        add_instagram_to_restaurant(restaurant['id'])
        break
      end
    end
  end

  def get_instagram_images(id)
    str = Nokogiri::HTML(open("https://www.instagram.com/explore/locations/#{id}")).to_s
    a = str.index('nodes')
    # z = str.index('top_posts')
    # response = str[a + 7..z - 5]
    # z = str.index('page_info')
    # response = str[a + 7..z-4]
    b = str[a..-1]
    z = b.index(']')
    response = b[8..z]
    parsed_response = ActiveSupport::JSON.decode(response)

    i = 0
    while i < parsed_response.count do
      thumb = parsed_response[i]['thumbnail_src']
      link = parsed_response[i]['code']

      r = Result.create(ig_slug: link, image: thumb, search_id: @search.id, restaurant_id: @restaurant.id)
      r.save

      ActionCable.server.broadcast('loading_channel', message: link,
                                                      thumb: thumb)
      i += 1
    end
  end

  def add_instagram_to_restaurant(igid)
    r = Restaurant.find_by(id: @restaurant.id)
    if r.ig_id.nil?
      r.ig_id = igid
      r.save
    end
  end
end
