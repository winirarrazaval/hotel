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
      my_data.reservations.last.cost.must_equal 2200
    end
  end

  describe "available?" do
    it "Should return an room ID between 1 and 20" do
      @data.reserve("2017-05-09", "2017-05-15").room_id.to_i.must_be :>=,1
      @data.reserve("2017-05-09", "2017-05-20").room_id.to_i.must_be :<=,20
    end

    it "Should raise an error if reserving 21 rooms for the same dates" do

      20.times do
        @data.reserve("2017-05-09", "2017-05-15")
      end
      @data.reservations.length.must_equal 20
      proc{@data.reserve("2017-05-09", "2017-05-15")}.must_raise ArgumentError
    end

    it "Should let you reserve a room starting the same date 20 reservations end" do
      20.times do
        @data.reserve("2017-05-09", "2017-05-15")
      end
      @data.reservations.length.must_equal 20
      @data.reserve("2017-05-15", "2017-05-16").must_be_instance_of Hotel::Reservation
    end

    describe "reservations_for_a_date" do
      it "Should give you a list of reservations for a specific date " do
        5.times do
          @data.reserve("2017-05-09", "2017-05-15")
        end
        3.times do
          @data.reserve("2017-05-15", "2017-05-16")
        end
        @data.reservations_for_a_date("2017-05-15").length.must_equal 3
      end
    end

    describe "available_rooms" do
      it "Should give an acurate number of rooms available for a specidic date" do
        @data.available_rooms("2017-05-16").length.must_equal 20
        3.times do
          @data.reserve("2017-05-14", "2017-05-18")
        end
        @data.available_rooms("2017-05-15").length.must_equal 17
        17.times do
          @data.reserve("2017-05-14", "2017-05-18")
        end
        @data.available_rooms("2017-05-15").length.must_equal 0
      end
    end
  end


end
