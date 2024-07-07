# frozen_string_literal: true

require "otenki"
require "thor"
require "net/http"
require "dotenv/load"
require_relative "constants"

module Otenki
  class CLI < Thor
    desc "Get the current weather for a specific city", "Pass city name to get weather information"
    def current_weather(city_name)
      uri = URI("#{Constants::WEATHER_URI}/current.json")
      params = { key: ENV['WEATHER_API_KEY'], q: city_name }
      uri.query = URI.encode_www_form(params)
      res = Net::HTTP.get_response(uri)
      puts res.body
    rescue StandardError => e
      puts "Error: #{e}"
    end

    # def forecast_weather_upto_three_days(city_name, days = 1)
    #   puts "Hello, #{city_name}"
    # end

    # def past_weather(city_name)
    #   puts "Hello, #{city_name}"
    # end
  end
end
