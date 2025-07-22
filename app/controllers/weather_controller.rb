require 'net/http'
require 'json'
require 'uri'

class WeatherController < ApplicationController

  # Your trusted city coordinates (add more as you want)
  CITY_COORDS = {
    "abuja" => "9.0579,7.4951",
    "lagos" => "6.5244,3.3792",
    "kano" => "12.0022,8.5919",
    "port harcourt" => "4.8156,7.0498"
  }

  def show
    input_city = params[:city].to_s.strip.downcase
    @city_entered = params[:city].presence || 'Lagos'

    # Use coords if city in dictionary, else fallback to user input name
    query = CITY_COORDS[input_city] || @city_entered

    url = URI("https://wttr.in/#{URI.encode_www_form_component(query)}?format=j1")

    res = Net::HTTP.get_response(url)

    if res.is_a?(Net::HTTPSuccess)
      data = JSON.parse(res.body)

      current = data.dig("current_condition", 0)
      nearest_area = data.dig("nearest_area", 0)
      actual_area = nearest_area.dig("areaName", 0, "value") rescue nil

      @actual_city = CITY_COORDS.key?(input_city) ? @city_entered : (actual_area || "Unknown")
      @temp = current["temp_C"] rescue nil
      @description = current.dig("weatherDesc", 0, "value") rescue nil

      if @temp.nil? || @description.nil?
        @error = "Could not parse weather data properly."
      end

        else
          @error = "Could not fetch weather data from the server."
        end
      end
    
    end


