class PlacesController < ApplicationController
  def index
  end

  def show
    if session[:last_search]
      @places = BeermappingApi.places_in(session[:last_search])
    end
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      session[:last_search]=params[:city]
      render :index
    end
  end
end