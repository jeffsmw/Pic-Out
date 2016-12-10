require 'fuzzystringmatch'

class HomeController < ApplicationController
  def index
  end

  def create
    # search = params[:search]
    lat = params[:lat]
    lng = params[:lng]

    # ## Get Zomato API for nearby restaurants ##
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
      zm_lat = restaurant['restaurant']['location']['latitude']
      zm_lng = restaurant['restaurant']['location']['longitude']
      puts zm_name
      get_instagram_api(zm_name, zm_lat, zm_lng)
      puts '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
    end
    head :no_content
  end

  ## Get Instagram locations near coordinates  ##
  def get_instagram_api(name, lat, lng)
    url = "https://api.instagram.com/v1/locations/search?lat=#{lat}&lng=#{lng}&access_token=#{ENV['INSTAGRAM_ACCESS_TOKEN']}"
    response = RestClient.get(url)
    parsed_response = ActiveSupport::JSON.decode(response)
    # parsed_response['data'][0]['name']

    # jarow = FuzzyStringMatch::JaroWinkler.create( :native )
    # best_match_pc = jarow.getDistance( name, parsed_response['data'][0]['name'])
    # best_rest = parsed_response['data'][0]['name']
    #
    parsed_response['data'].each do |restaurant|
      jarow = FuzzyStringMatch::JaroWinkler.create(:native)
      match = jarow.getDistance(name, restaurant['name'])
      # if match > best_match_pc
      #   best_rest = restaurant['name']
      #   best_match_pc = match
      #   p best_rest
      #   p best_match_pc
      # end
      if match > 0.75
        puts match
        puts restaurant['name']
        break if restaurant['id'] == '0'
        # ActionCable.server.broadcast('loading_channel', {message: restaurant['name']})
        get_instagram_images(restaurant['id'])
        break
      end
    end
  end

  def get_instagram_images(id)
    str = Nokogiri::HTML(open("https://www.instagram.com/explore/locations/#{id}")).to_s
    a = str.index('nodes')
    z = str.index('top_posts')
    response = str[a + 7..z - 5]
    parsed_response = ActiveSupport::JSON.decode(response)

    thumb = parsed_response[0]['thumbnail_src']
    image = parsed_response[0]['display_src']
    link = parsed_response[0]['code']

    ActionCable.server.broadcast('loading_channel', message: link,
                                                    thumb: thumb,
                                                    image: image)
    #<<TODO
  end
end
