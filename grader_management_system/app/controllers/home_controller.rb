class HomeController < ApplicationController
  def index
  end
  # Method to handle non-existent routes (404)
  def route_not_found
    redirect_to root_path, alert: 'Page not found'
  end
end
