# Hotel System

A friend of ours in an heiress and she seeks our assistance in creating a hotel management system. This system will be used primarily by employees working at the front desk as people


## Wave One
- As an administrator, I should be able to view the availability of rooms for a given date range
- As an administrator, I should be able to reserve an available room for a given date range

Assume that there is only a single room rate or $200/night to start with.

### Think About
- Are you preventing invalid date ranges?
- What happens when there are no rooms available?
- Do you prevent reserving a room that is already reserved? 

## Wave Two
- As an administrator, I should be able to create a new Block of Rooms
  - For a date range, collection of rooms and an adjusted discounted rate
- As an administrator, I should be able to able to view the availability for a room within a block of rooms
- As an administrator, I should be able to reserve an available room from within a block of rooms

Assume that when a room is reserved from a block of rooms, it will **always** match the date range of the block.

## Optional
- As an administrator, I should be able to set different rates for different rooms
- As an administrator, I should be able to create an invoice for a given room reservation
