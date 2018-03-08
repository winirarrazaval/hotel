require_relative "admin"
require "date"
require "pry"
require_relative "reservation"


module Hotel
  class RoomBlock
    attr_reader :blocked_rooms, :start_date, :end_date, :rate, :block_id, :reservations_in_this_block
    def initialize(info_hash)
      @blocked_rooms = info_hash[:blocked_rooms]
      @start_date = Date.parse(info_hash[:start_date])
      @end_date = Date.parse(info_hash[:end_date])
      @rate = info_hash[:rate]
      @reservations_in_this_block = []
      @block_id = info_hash[:block_id]

      if @start_date > @end_date
        raise ArgumentError.new("Start date must be before end date")
      end 
    end

    def add_reservation(reservation)
      @reservations_in_this_block << reservation
    end

  end
end
