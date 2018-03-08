require "date"
require "pry"
require_relative "reservation"
require_relative "room_block"

module Hotel

  class Admin
    attr_reader :reservations, :room_ids, :room_blocks

    def initialize(room_quantity)
      @reservations = []
      @room_quantity = room_quantity
      @room_ids = []
      @room_blocks = []
      @room_block_ids = []

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

    def find_block_id(block_id)
      @room_blocks.each do |block|
        if block.block_id == block_id
          return block
        end
      end
      raise ArgumentError.new("That Block id does not exist")
    end

    def unavailable_rooms(start_date, end_date, block_id: nil)
      start_ = Date.parse(start_date)
      end_ = Date.parse(end_date)
      unavailable_rooms_array = []
      unavailable_room_in_block = []

      if block_id != nil
        the_block = find_block_id(block_id)
        the_block.reservations_in_this_block.each do |reservation|
          range = (reservation.start_date..(reservation.end_date - 1))
          if range === start_ || range === end_
            unavailable_room_in_block << reservation.room_id
          end
        end
        return unavailable_room_in_block
      end

      if block_id == nil
        @room_blocks.each do |block|
          range = (block.start_date..(block.end_date - 1))
          if range === start_ || range === end_
            block.blocked_rooms.each do |room|
              unavailable_rooms_array << room
            end
          end
        end
      end
      @reservations.each do |reservation|
        range = (reservation.start_date..(reservation.end_date - 1))
        if range === start_ || range === end_
          unavailable_room = reservation.room_id
          unavailable_rooms_array << unavailable_room
        end
      end
      return unavailable_rooms_array
    end


    def available_rooms(start_date, end_date, block_id: nil)
      the_room_options = (@room_ids - (@room_ids && unavailable_rooms(start_date, end_date, block_id: block_id)))
      # the_room_options = []
      # @room_ids.each do |room|
      #   unless unavailable_rooms(start_date, end_date, block_id: block_id).include?(room)
      #     the_room_options << room
      #   end
      # end


      unless (block_id == nil)
        my_block = find_block_id(block_id)
        block_available_rooms = (my_block.blocked_rooms - (my_block.blocked_rooms && unavailable_rooms(start_date, end_date, block_id: block_id)))
        if block_available_rooms.length == 0
          return raise ArgumentError.new("All the rooms in this block are booked!")
        end
        return block_available_rooms
      end
      if (the_room_options == [] )
        raise ArgumentError.new("Sorry! Full rooms!")
      else
        return the_room_options
      end
    end


    def create_block_id
      block_id =  @room_block_ids.last.to_s.to_i + 1
      @room_block_ids << block_id
      return block_id
    end

    def create_block(number_of_rooms, start_date, end_date, rate: 100)
      return raise ArgumentError.new("max. blocked rooms is 5") if number_of_rooms > 5

      blocked_hash = {
        block_id: create_block_id,
        blocked_rooms: available_rooms(start_date, end_date).sample(number_of_rooms),
        start_date: start_date,
        end_date: end_date,
        rate: rate
      }
      new_block = RoomBlock.new(blocked_hash)
      @room_blocks << new_block
      return new_block
    end

    def reserve(start_date, end_date, rate: 200, block_id: nil)
      info = {
        room_id: available_rooms(start_date, end_date, block_id: block_id).sample,
        start_date: Date.parse(start_date),
        end_date: Date.parse(end_date),
        rate: rate,
        block_id: block_id
      }

      if info[:block_id] != nil
        the_block = find_block_id(info[:block_id])
        range = (the_block.start_date..(the_block.end_date))
        unless (range === info[:start_date]) && (range === info[:end_date])
          raise ArgumentError.new("The start and end date must be in the block date range")
        end
        info[:rate] = the_block.rate
        new_reservation = Reservation.new(info)
        the_block.add_reservation(new_reservation)
      else
        new_reservation = Reservation.new(info)
      end
      @reservations << new_reservation
      return new_reservation

    end
  end
end
