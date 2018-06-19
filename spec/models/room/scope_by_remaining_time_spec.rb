require "rails_helper"

RSpec.describe Room, type: :model do

  describe "#by_remaining_time scope" do
    it "should return the list of rooms ordered by expired_at in asc order" do
      last_expiring_room = create :room, expires_at: 5.minutes.from_now
      first_expiring_room = create :room, expires_at: 4.minutes.from_now
      rooms = Room.all
      expect(rooms.count).to be 2
      expect(rooms.first).to eq last_expiring_room
      expect(rooms.last).to eq first_expiring_room

      rooms_by_remaining_time = Room.by_remaining_time
      expect(rooms_by_remaining_time.size).to be 2
      expect(rooms_by_remaining_time.first).to eq first_expiring_room
      expect(rooms_by_remaining_time.last).to eq last_expiring_room
    end
  end

end
