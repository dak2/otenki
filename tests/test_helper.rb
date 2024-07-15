# frozen_string_literal: true

require "bundler/setup"
require "minitest/autorun"

dir = __dir__ #: String
$LOAD_PATH.unshift File.expand_path("../lib", dir)
require "otenki"
