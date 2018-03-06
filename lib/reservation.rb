require "date"

module Hotel
  class Reservation
    attr_reader :room_id, :start_date, :end_date, :cost
    def initialize(info_hash)
      @room_id = info_hash[:room_number]
      @start_date = info_hash[:start_date]
      @end_date = info_hash[:end_date]
      @cost = cost

      if @start_date >= @end_date
        raise ArgumentError.new("The start date must be before end date")
      end
    end

    def cost
      days = (@end_date - @start_date).to_i
      cost_per_night = 200
      return (days * cost_per_night)
    end

  end
end
