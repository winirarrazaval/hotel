require_relative "spec_helper"

describe "RoomBlock" do
  before do
    info = {
      blocked_rooms: [3,5,2],
      start_date: ("2017-05-07"),
      end_date: ("2017-05-10"),
      rate: 100
    }

    @block = Hotel::RoomBlock.new(info)
  end



  describe "initialize" do
    it "Should create a new instance of RoomBlock" do
      @block.must_be_instance_of Hotel::RoomBlock
    end
    it "Should raise an error if the block has a start date later than the end date" do
      info = {
        blocked_rooms: [3,5,2],
        start_date: ("2017-05-07"),
        end_date: ("2017-05-05"),
        rate: 100
      }
      proc {block = Hotel::RoomBlock.new(info)}.must_raise ArgumentError
      
    end
  end
end
