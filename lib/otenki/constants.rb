# rbs_inline: enabled
# frozen_string_literal: true

require "yaml"

module Otenki
  class Constants
    dir = __dir__ #: String
    WEATHER_URI = "https://api.weatherapi.com/v1".freeze #: String
    ERROR_MESSAGES = YAML.load_file(File.expand_path("../errors/messages.yml", dir)) #: Hash[String, Hash[String,Hahs[String, String]]
    FORECAST_WEATHER_UP_TO_3_DAYS = ERROR_MESSAGES["otenki"]["errors"]["forecast_weather_up_to_3_days"] #: String
    FETCH_WEATHER_UP_TO_PAST_7_DAYS = ERROR_MESSAGES["otenki"]["errors"]["fetch_weather_up_to_past_7_days"] #: String

    private_constant :ERROR_MESSAGES
  end
end
