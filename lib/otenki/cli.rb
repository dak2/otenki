# rbs_inline: enabled
# frozen_string_literal: true

require "otenki"
require "thor"
require "uri"
require "net/http"
require "dotenv/load"
require "date"
require_relative "constants"

module Otenki
  class CLI < Thor
    # This method is defined in the Thor gem, so can't be typed by rbs-inline
    desc "Get the current weather for a specific city", "Pass city name to get weather information"

    # @rbs city_name: String
    # @rbs return: void
    def current_weather(city_name)
      uri = URI("#{Constants::WEATHER_URI}/current.json")
      params = { key: ENV["WEATHER_API_KEY"], q: city_name, lang: "ja" }
      uri.query = URI.encode_www_form(params)
      res = Net::HTTP.get_response(uri)
      puts res.body
    rescue StandardError => e
      puts "Error: #{e}"
    end

    # This method is defined in the Thor gem, so can't be typed by rbs-inline
    desc "Get the future weather until specific days", "Pass city name, days to get weather information"

    # @rbs city_name: String
    # @rbs days: String -- up_to: 3
    # @rbs return: void
    def forecast_weather(city_name, days = "1")
      input_days = days.to_i
      raise Otenki::Error, "予報できる天気は今日から3日までです" if input_days > 3

      uri = URI("#{Constants::WEATHER_URI}/forecast.json")
      params = { key: ENV["WEATHER_API_KEY"], days: input_days, q: city_name, lang: "ja" }
      uri.query = URI.encode_www_form(params)
      res = Net::HTTP.get_response(uri)
      puts res.body
    rescue StandardError => e
      puts "Error: #{e}"
    end

    # This method is defined in the Thor gem, so can't be typed by rbs-inline
    desc "Get the past weather until specific days", "Pass city name, days to get weather information"

    # @rbs city_name: String
    # @rbs days: String -- up_to: 7
    # @rbs return: void
    def past_weather(city_name, days = "1")
      current_date = Date.today
      past_date = current_date.prev_day(days.to_i)
      raise Otenki::Error, "取得できる天気は過去7日間までです" if past_date < current_date.prev_day(7)

      uri = URI("#{Constants::WEATHER_URI}/history.json")
      params = { key: ENV["WEATHER_API_KEY"], dt: past_date.to_s, q: city_name, lang: "ja" }
      uri.query = URI.encode_www_form(params)
      res = Net::HTTP.get_response(uri)
      puts res.body
    rescue StandardError => e
      puts "Error: #{e}"
    end
  end
end
