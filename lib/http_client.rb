# rbs_inline: enabled
# frozen_string_literal: true

require "uri"
require "net/http"

class HttpClient
  attr_reader :base_path, :base_params

  # @rbs base_path: String
  # @rbs base_params: Hash[Symbol, String | Integer | nil]
  def initialize(base_path, base_params)
    @base_path = base_path
    @base_params = base_params
  end

  # @rbs params: Hash[Symbol, String | Integer | nil]
  # @rbs return: String
  def get_response(path, params)
    uri = URI("#{base_path}/#{path}")
    uri.query = URI.encode_www_form(request_params(params))
    res = Net::HTTP.get_response(uri)
    res.body
  end

  private

  # @rbs params: Hash[Symbol, String | Integer | nil]
  # @rbs return: Hash[Symbol, String | Integer | nil]
  def request_params(params)
    base_params.merge(params)
  end
end
