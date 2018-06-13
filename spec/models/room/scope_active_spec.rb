require "rails_helper"

RSpec.describe Room, type: :model do

  describe "#active scope" do
    it "should return only the rooms that are not expired" do
      active_room = create :room
      expired_room = create :room, expires_at: 1.minute.ago
      expect(Room.count).to be 2

      rooms_active = Room.active
      expect(rooms_active.size).to be 1
      expect(rooms_active).to include active_room
      expect(rooms_active).to_not include expired_room
    end
  end

end
