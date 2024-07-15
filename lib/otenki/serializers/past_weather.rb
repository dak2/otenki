# rbs_inline: enabled
# frozen_string_literal: true

require "json"

module Otenki
  module Serializers
    class PastWeather
      # @rbs response: String
      # @rbs index: Integer
      # @rbs return: String
      # rubocop:disable Metrics/AbcSize, Metrics/MethodLength,Lint/MissingCopEnableDirective
      def self.serialize(response)
        data = JSON.parse(response)
        {
          "Country" => data.dig("location", "country"),
          "City" => data.dig("location", "name"),
          "ForecastDate" => data["forecast"]["forecastday"].first["hour"].first["time"],
          "Temperature(°C)" => data["forecast"]["forecastday"].first["hour"].first["temp_c"],
          "Condition" => data["forecast"]["forecastday"].first["hour"].first["condition"]["text"],
          "Wind" => "#{data["forecast"]["forecastday"].first["hour"].first["wind_kph"]} km/h",
          "Humidity" => "#{data["forecast"]["forecastday"].first["hour"].first["humidity"]}%",
          "Feels Like" => "#{data["forecast"]["forecastday"].first["hour"].first["feelslike_c"]}°C"
        }.map { |k, v| "#{k}: #{v}" }.join("\n")
      end
    end
  end
end
