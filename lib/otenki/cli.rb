# rbs_inline: enabled
# frozen_string_literal: true

require "otenki"
require "thor"
require "dotenv/load"
require "date"
require_relative "constants"
require_relative "serializers/current_weather"
require_relative "serializers/forecast_weather"
require_relative "serializers/past_weather"
require_relative "../http_client"

module Otenki
  class CLI < Thor
    desc "Get the current weather for a specific city", "Pass city name to get weather information"

    # @rbs city_name: String
    # @rbs return: void
    def current_weather(city_name)
      res = http_client.get_response("current.json", { q: city_name })
      puts Serializers::CurrentWeather.serialize(res)
    rescue StandardError => e
      puts "Error: #{e}"
    end

    desc "Get the future weather until specific days", "Pass city name, days to get weather information"

    # @rbs city_name: String
    # @rbs days: String -- up_to: 3
    # @rbs return: void
    def forecast_weather(city_name, days = "1")
      input_days = days.to_i
      validate_days(input_days, type: :forecast)

      res = http_client.get_response("forecast.json", { q: city_name, days: input_days })
      puts Serializers::ForecastWeather.serialize(res, input_days - 1)
    rescue StandardError => e
      puts "Error: #{e}"
    end

    desc "Get the past weather until specific days", "Pass city name, days to get weather information"

    # @rbs city_name: String
    # @rbs days: String -- up_to: 7
    # @rbs return: void
    def past_weather(city_name, days = "1")
      input_days = days.to_i
      validate_days(input_days, type: :past)
      past_date = Date.today.prev_day(input_days)

      res = http_client.get_response("history.json", { dt: past_date.to_s, q: city_name })
      puts Serializers::PastWeather.serialize(res)
    rescue StandardError => e
      puts "Error: #{e}"
    end

    private

    # @rbs return: HttpClient
    def http_client
      @http_client ||= HttpClient.new(Constants::WEATHER_URI, { key: ENV["WEATHER_API_KEY"], lang: "ja" })
    end

    # @rbs days: Integer
    # @rbs type: Symbol
    # @rbs return: void
    def validate_days(days, type:)
      raise Otenki::Error, Constants::MUST_BE_POSITIVE_INTEGER if days <= 0

      case type
      when :forecast
        raise Otenki::Error, Constants::FORECAST_WEATHER_UP_TO_3_DAYS if days > 3
      when :past
        raise Otenki::Error, Constants::FETCH_WEATHER_UP_TO_PAST_7_DAYS if days > 7
      end
    end
  end
end
