require "date"

module Hotel
  class Admin
    attr_reader :reservations, :room_ids
    def initialize(room_quantity)
      @reservations = []
      @room_quantity = room_quantity
      @room_ids = []

      i=1
      until i == (@room_quantity + 1)
        room_id = "R#{i}"
        i += 1
        @room_ids << room_id
      end
    end





    def full_dates

    end

    def available?(start_date, end_date)
      if reservations == []
        return @room_ids.sample
      end
      wanted_start_date = start_date
      wanted_end_date = end_date
      unavailable_rooms = []
      available_rooms = []
      reservations.each do |reservation|
        range = (reservation.start_date..reservation.end_date)
        if range === wanted_start_date || range == wanted_end_date
          unavailable_room = reservation.room_id
          unavailable_rooms << unavailable_room
        else
          available_rooms << reservation.room_id
        end
        the_room_options = []
        available_rooms.each do |room|
          unless unavailable_rooms.include?(room)
            the_room_options << room
          end
        end
        if (the_room_options == [] )
          raise ArgumentError.new("Sorry! Full rooms!")
        else
          return the_room_options.sample
        end

      end
    end

    def reserve(start_date, end_date)
      #I am not sure if I can check dates for the same thing twice, do I have to choose?
      if Date.parse(start_date) > Date.parse(end_date)
        raise ArgumentError.new("Start date must be after end date.")
      end
      info = {
        room_id: available?(start_date,end_date),
        start_date: Date.parse(start_date),
        end_date: Date.parse(end_date)
      }


      new_reservation = Reservation.new (info)
      @reservations << new_reservation
      return new_reservation
    end

  end
end

#reservation = Hotel::Admin.new(20)
#puts reservation.reserve((2017,07,05),(2017,07,06))
