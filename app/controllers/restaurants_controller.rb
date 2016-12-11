class RestaurantsController < ApplicationController
  def show
    id = params[:id]
    @restaurant = Restaurant.find_by(id: id)
  end
end
