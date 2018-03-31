module Hotel
  class Time
    initialize(start_date, end_date, block_id: nil)
    @start_date = start_date
    @end_date = end_date
    @block_id = block_id
  end
