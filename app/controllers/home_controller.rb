class HomeController < ApplicationController

  def index
    ## WORKING ##
    # str = (Nokogiri::HTML(open('https://www.instagram.com/explore/locations/1001652496/cocoru/'))).to_s
    # str = (Nokogiri::HTML(open('https://www.instagram.com/explore/locations/722341822/chatime-richmond/'))).to_s
    # a = str.index('nodes')
    # aStr = str[a..-1]
    # z = aStr.index('top_posts')
    # zStr = aStr[7..z-5]
    # @char = zStr
    # render :json => zStr
  end

  def show
    # str = (Nokogiri::HTML(open('https://www.instagram.com/explore/locations/722341822/chatime-richmond/'))).to_s
    # a = str.index('nodes')
    # z = str.index('top_posts')
    # render :json => str[a+7..z-5]
    @search = params[:search]
  end
end
