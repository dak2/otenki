# rbs_inline: enabled
# frozen_string_literal: true

require_relative "../test_helper"

class CLITest < Minitest::Test
  # @rbs return: void
  def setup
    dir = __dir__ #: String
    @cli = Otenki::CLI.new
    @http_client = Minitest::Mock.new
    @responses = YAML.load_file(File.expand_path("../mocks/api_response.yml", dir))
  end

  # @rbs return: void
  def test_current_weather
    # setup mock
    api_response = JSON.parse(@responses["tests"]["mocks"]["response"]["current_weather"])
    @http_client.expect(:get_response, api_response, ["current.json", { q: "Tokyo" }])

    # setup response
    expected_response = <<~EXPECTED
      Country: Japan
      City: Tokyo
      Temperature(°C): 32.7
      Condition: 晴れ
      Wind: 5.8 km/h
      Humidity: 51%
      Feels Like: 36.5°C
    EXPECTED

    @cli.stub(:http_client, @http_client) do
      output = capture_io { @cli.current_weather("Tokyo") }.first
      assert_match(expected_response, output)
    end

    @http_client.verify

    # 異常系のテスト（city_nameがString以外の場合）
    error_message = "Error: 市名は文字列で入力してください。"

    # 数値の場合
    assert_output(/#{Regexp.escape(error_message)}/) { @cli.current_weather(123) }

    # 配列の場合
    assert_output(/#{Regexp.escape(error_message)}/) { @cli.current_weather(["Tokyo"]) }

    # ハッシュの場合
    assert_output(/#{Regexp.escape(error_message)}/) { @cli.current_weather({ city: "Tokyo" }) }
  end

  # @rbs return: void
  def test_forecast_weather
    # setup mock
    api_response = JSON.parse(@responses["tests"]["mocks"]["response"]["forecast_weather"])
    @http_client.expect(:get_response, api_response, ["forecast.json", { q: "Tokyo", days: 1 }])

    # setup response
    expected_response = <<~EXPECTED
      Country: Japan
      City: Tokyo
      ForecastDate: 2024-07-21 00:00
      Temperature(°C): 27.9
      Condition: 晴れ
      Wind: 8.3 km/h
      Humidity: 71%
      Feels Like: 30.9°C
    EXPECTED

    @cli.stub(:http_client, @http_client) do
      output = capture_io { @cli.forecast_weather("Tokyo", "1") }.first
      assert_match(expected_response, output)
    end

    @http_client.verify

    # 異常系のテスト（daysが正の正数ではない）
    error_message = "Error: 正の整数で入力してください。"

    # 0の場合
    assert_output(/#{Regexp.escape(error_message)}/) { @cli.forecast_weather("Tokyo", "0") }

    # 負の数の場合
    assert_output(/#{Regexp.escape(error_message)}/) { @cli.forecast_weather("Tokyo", "-1") }

    # 数値以外の場合
    assert_output(/#{Regexp.escape(error_message)}/) { @cli.forecast_weather("Tokyo", "Ginza") }
  end

  # @rbs return: void
  def test_past_weather
    # setup mock
    Time.stub :now, Time.new(2024, 7, 21, 0, 0, 0) do
      api_response = JSON.parse(@responses["tests"]["mocks"]["response"]["past_weather"])
      @http_client.expect(:get_response, api_response,
                          ["history.json", { q: "Tokyo", dt: Date.today.prev_day(1).to_s }])

    # setup response
    expected_response = <<~EXPECTED
      Country: Japan
      City: Tokyo
      ForecastDate: 2024-07-20 00:00
      Temperature(°C): 28.9
      Condition: 晴れ
      Wind: 3.6 km/h
      Humidity: 74%
      Feels Like: 33.2°C
    EXPECTED

      @cli.stub(:http_client, @http_client) do
        output = capture_io { @cli.past_weather("Tokyo", "1") }.first
        assert_match(expected_response, output)
      end

      # validateのケース

      @http_client.verify

      # 異常系のテスト（daysが正の正数ではない）
      error_message = "Error: 正の整数で入力してください。"

      # 0の場合
      assert_output(/#{Regexp.escape(error_message)}/) { @cli.past_weather("Tokyo", "0") }

      # 負の数の場合
      assert_output(/#{Regexp.escape(error_message)}/) { @cli.past_weather("Tokyo", "-1") }

      # 数値以外の場合
      assert_output(/#{Regexp.escape(error_message)}/) { @cli.past_weather("Tokyo", "Ginza") }
    end
  end
end
