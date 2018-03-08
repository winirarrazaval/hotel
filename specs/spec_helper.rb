require 'time'
require 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'
# Add simplecov

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

# Require_relative your lib files here!
require_relative '../lib/reservation.rb'
require_relative '../lib/admin.rb'
require_relative '../lib/room_block.rb'
# require_relative '../lib/'
