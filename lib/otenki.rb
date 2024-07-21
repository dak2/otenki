# rbs_inline: enabled
# frozen_string_literal: true

require_relative "otenki/version"
require "otenki/cli"

module Otenki
  class Error < StandardError
    # @rbs msg: String
    # @rbs return: Otenki::Error
    def initialize(msg = "Error occurred")
      super
    end
  end
end
