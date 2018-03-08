require_relative "spec_helper"

describe "Reservation" do
  before do
    info = {
      room_id: 3,
      start_date: Date.new(2017,07,04),
      end_date: Date.new(2017,07,06),
      rate: 200
    }
    @reservation = Hotel::Reservation.new(info)
  end

  describe "initialize" do
    it "Should create an instance of reservation" do
      @reservation.must_be_instance_of Hotel::Reservation

    end

    it "The room should have an  id_number must be an integer between 1 and 20" do
      @reservation.room_id.must_be :>, 1
      @reservation.room_id.must_be :<, 20
    end

    it "Should have an earlier start_date than end_date" do
      @reservation.start_date.must_be :<, @reservation.end_date

    end

    it "Should raise an error if the start date is equal or greater than end date" do
      infox = {
        room_id: 3,
        start_date: Date.new(2017,06,05),
        end_date: Date.new(2017,05,05),
        rate: 200
      }
      proc{ Hotel::Reservation.new(infox)}.must_raise ArgumentError
    end
  end

  describe "cost" do
    it "Should return and integer" do
      @reservation.cost.must_equal 400
    end
  end

  describe "add_night" do
  end

  describe "remove_night" do
  end

  describe "cancel_reservation" do
  end
end
