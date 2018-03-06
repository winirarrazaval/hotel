require_relative "spec_helper"
require "time"

describe "Admin" do
  before do
    @data = Hotel::Admin.new(20)

  end
  describe "Initialize" do
    it "Should create an empty array to store instances of reservations" do
      @data.reservations.must_equal []
    end
    it "Should create and array of IDs with the legth of the quantity of rooms " do
      @data.room_ids.length.must_equal 20
    end
  end

  describe " reserve " do
    it  "Must return and instance of reservation" do
      start = ("2017-07-05")
      endd = ("2017-07-06")
      @data.reserve(start,endd).must_be_instance_of Hotel::Reservation
    end

    it "Must raise an error if the start date if after end date" do
      proc{@data.reserve("2017-07-06","2017-07-05")}.must_raise ArgumentError
    end

    it "Should increase in one the number of reservations" do
      my_data = @data
      before_length = my_data.reservations.length
      my_data.reserve("2017-05-09", "2017-05-20")
      my_data.reservations.length.must_equal (before_length + 1)

    end
  end
end
