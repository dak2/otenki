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
    expected_response = @responses["tests"]["mocks"]["response"]["current_weather"]
    @http_client.expect(:get_response, expected_response, ["current.json", { q: "Tokyo" }])

    @cli.stub(:http_client, @http_client) do
      output = capture_io { @cli.current_weather("Tokyo") }.first
      assert_match(expected_response, output)
    end

    @http_client.verify
  end

  # @rbs return: void
  def test_forecast_weather
    # setup mock
    expected_response = @responses["tests"]["mocks"]["response"]["forecast_weather"]
    @http_client.expect(:get_response, expected_response, ["forecast.json", { q: "Tokyo", days: 1 }])

    @cli.stub(:http_client, @http_client) do
      output = capture_io { @cli.forecast_weather("Tokyo", "1") }.first
      assert_match(expected_response, output)
    end

    @http_client.verify
  end

  # @rbs return: void
  def test_past_weather
    # setup mock
    Time.stub :now, Time.new(2024, 7, 15, 0, 0, 0) do
      expected_response = @responses["tests"]["mocks"]["response"]["past_weather"]
      @http_client.expect(:get_response, expected_response,
                          ["history.json", { q: "Tokyo", dt: Date.today.prev_day(1).to_s }])

      @cli.stub(:http_client, @http_client) do
        output = capture_io { @cli.past_weather("Tokyo", "1") }.first
        assert_match(expected_response, output)
      end

      @http_client.verify
    end
  end
end
