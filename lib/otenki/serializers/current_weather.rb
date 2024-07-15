# rbs_inline: enabled
# frozen_string_literal: true

require "json"

module Otenki
  module Serializers
    class CurrentWeather
      # @rbs response: String
      # @rbs return: String
      def self.serialize(response)
        data = JSON.parse(response)
        {
          "Country" => data.dig("location", "country"),
          "City" => data.dig("location", "name"),
          "Temperature(°C)" => data.dig("current", "temp_c"),
          "Condition" => data.dig("current", "condition", "text"),
          "Wind" => "#{data.dig("current", "wind_kph")} km/h",
          "Humidity" => "#{data.dig("current", "humidity")}%",
          "Feels Like" => "#{data.dig("current", "feelslike_c")}°C"
        }.map { |k, v| "#{k}: #{v}" }.join("\n")
      end
    end
  end
end
