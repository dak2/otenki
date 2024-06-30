require "otenki"
require "thor"

module Otenki
  class CLI < Thor
    desc "test NAME", "Test method to say hello to NAME"
    def test(name)
      puts "Hello, #{name}"
    end
  end
end
