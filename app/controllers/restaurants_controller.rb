class RestaurantsController < ApplicationController
  def show
    id = params[:id]
    @restaurant = Restaurant.find_by(id: id)
    @results = Result.where(restaurant_id: id)
    @origin = @restaurant.address
    @final = @restaurant.address
    @key = ENV['GOOGLE_MAPS_ACCESS_TOKEN']
    respond_to do |format|
      format.js { render :show }
      format.html { render :show }
    end
  end

  # map directions
  def create
    @origin = params[:origin].gsub!(', ',',').gsub(/\s/,'+').gsub('&','%26')
    @final = params[:addr].gsub!(', ',',').gsub(/\s/,'+')
    @key = ENV['GOOGLE_MAPS_ACCESS_TOKEN']
    respond_to do |format|
      format.js { render :new }
      format.html { render :new }
    end
  end

  def index
    respond_to do |format|
      format.js { render :index }
      format.html { render :index }
    end
  end
end
