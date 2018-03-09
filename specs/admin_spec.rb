require_relative "spec_helper"
require "time"
require "pry"

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

    it "When reservion in a block, the block instance must change" do
      block = @data.create_block(3, "2017-05-09", "2017-05-20" )
      block.blocked_rooms.length.must_equal 3
      new_reservation =@data.reserve("2017-05-09", "2017-05-20", block_id: block.block_id)
      block.reservations_in_this_block.length.must_equal 1
      new_reservation.cost.must_equal 1100
    end

    it "Should raise an error when reserving more than the rooms in a block" do
      block = @data.create_block(3, "2017-05-09", "2017-05-20" )
      3.times do
        @data.reserve("2017-05-09", "2017-05-20", block_id: block.block_id)
      end
      block.blocked_rooms.length.must_equal 3
      block.reservations_in_this_block.length.must_equal 3
      proc {@data.reserve("2017-05-09", "2017-05-20", block_id: block.block_id)}.must_raise ArgumentError
    end

    it "Should raise an error if trying to reserve in a block on dates not in the block" do
      block = @data.create_block(3, "2017-05-09", "2017-05-20" )
      proc {@data.reserve("2017-05-09", "2017-05-22", block_id: block.block_id)}.must_raise ArgumentError
    end

    it "Should let you make many reservation in a block if dates are between the range, and it should let you make as many as you can if rooms available" do

      block = @data.create_block(3, "2017-05-09", "2017-05-20")
      @data.reserve("2017-05-09", "2017-05-10", block_id: block.block_id)
      @data.reserve("2017-05-10", "2017-05-11", block_id: block.block_id)
      @data.reserve("2017-05-11", "2017-05-13", block_id: block.block_id)
      @data.reserve("2017-05-13", "2017-05-16", block_id: block.block_id)
      @data.reserve("2017-05-16", "2017-05-20", block_id: block.block_id)
      @data.reserve("2017-05-09", "2017-05-13", block_id: block.block_id)
      @data.reserve("2017-05-13", "2017-05-14", block_id: block.block_id)
      @data.reserve("2017-05-15", "2017-05-16", block_id: block.block_id)
      block.reservations_in_this_block.length.must_equal 8
    end
  end



  describe "available_rooms" do

    it "Should give an acurate number of rooms available for a specidic date" do
      @data.available_rooms("2017-05-16", "2017-05-18").length.must_equal 20
      3.times do
        @data.reserve("2017-05-14", "2017-05-18")
      end
      @data.available_rooms("2017-05-15", "2017-05-16").length.must_equal 17
      17.times do
        @data.reserve("2017-05-14", "2017-05-18")
      end
      proc{@data.available_rooms("2017-05-16","2017-05-17")}.must_raise ArgumentError
    end

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

    it "Should give you the correct rooms available for a block" do
      block = @data.create_block(4, "2017-05-09", "2017-05-15")
      @data.available_rooms("2017-05-09", "2017-05-15", block_id: block.block_id).length.must_equal 4
    end

    it "Should give you the correct rooms available for a block if you have more than one block" do
      first_block =  @data.create_block(4, "2017-05-09", "2017-05-15")
      second_block = @data.create_block(5, "2017-05-15", "2017-05-20")
      @data.available_rooms("2017-05-09", "2017-05-15", block_id: first_block.block_id).length.must_equal 4
      @data.available_rooms("2017-05-15", "2017-05-20", block_id: second_block.block_id).length.must_equal 5
    end
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

  describe "create_block" do
    it "Should create a new instance of RoomBlock" do
      @data.create_block(3, "2017-05-15", "2017-05-16").must_be_instance_of Hotel::RoomBlock
      @data.room_blocks.last.rate.must_equal 100
    end
    it "should add a new instance of RoomBlock to room_blocks instance variable" do
      before =  @data.room_blocks.length
      @data.create_block(3, "2017-05-15", "2017-05-16")
      @data.room_blocks.length.must_equal (before + 1)
    end
    it "Should raise an error if creating a block with more than 5 rooms" do
      proc {@data.create_block(6, "2017-05-15", "2017-05-16")}.must_raise ArgumentError
    end
    it "should raise an error if creating a block and there are not rooms available" do
      @data.create_block(5, "2017-05-15", "2017-05-16")
      @data.create_block(5, "2017-05-15", "2017-05-16")
      @data.create_block(5, "2017-05-15", "2017-05-16")
      @data.create_block(5, "2017-05-15", "2017-05-16")
      @data.room_blocks.length.must_equal 4
      proc{@data.create_block(3, "2017-05-15", "2017-05-16")}.must_raise ArgumentError
    end
  end



  describe "find_block_id" do
    it "Should return an instance of RoomBlock" do
      block = @data.create_block(3, "2017-05-15", "2017-05-16")
      @data.find_block_id(block.block_id).must_be_instance_of Hotel::RoomBlock
    end
    it "Should raise an error is block does not exist" do
      proc{@data.find_block_id(5)}.must_raise ArgumentError
    end
  end
end
