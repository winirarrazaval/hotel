require "date"
require "pry"
require_relative "reservation"

module Hotel
  class Admin
    attr_reader :reservations, :room_ids
    def initialize(room_quantity)
      @reservations = []
      @room_quantity = room_quantity
      @room_ids = []

      i=1
      until i == (@room_quantity + 1)
        room_id = i
        i += 1
        @room_ids << room_id
      end
    end



    def reservations_for_a_date(date)
      reservations_date = []
      the_date = Date.parse(date)

      @reservations.each do |reservation|
        range = (reservation.start_date..(reservation.end_date - 1))
        if range === the_date
          reservations_date << reservation
        end
      end
      return reservations_date
    end


    def available_rooms(start_date, end_date)
      start_ = Date.parse(start_date)
      end_ = Date.parse(end_date)
      unavailable_rooms = []


      @reservations.each do |reservation|
        range = (reservation.start_date..(reservation.end_date - 1))
        if range === start_ || range === end_
          unavailable_room = reservation.room_id
          unavailable_rooms << unavailable_room
        end
      end

      the_room_options = []

      @room_ids.each do |room|
        unless unavailable_rooms.include?(room)
          the_room_options << room
        end
      end

      if (the_room_options == [] )
        raise ArgumentError.new("Sorry! Full rooms!")
      else
        return the_room_options
      end

    end

    def reserve(start_date, end_date)
      info = {
        room_id: available_rooms((start_date),(end_date)).sample,
        start_date: Date.parse(start_date),
        end_date: Date.parse(end_date)
      }

      new_reservation = Reservation.new(info)
      @reservations << new_reservation

      return new_reservation
    end
  end
end
