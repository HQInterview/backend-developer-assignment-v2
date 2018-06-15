require "rails_helper"

RSpec.describe Room, type: :model do

  describe "#active?" do
    it "should return true if the room is still active to receive bids" do
      not_active_room = create :room, expires_at: 1.second.ago
      active_room = create :room, expires_at: 3.seconds.from_now

      expect(active_room.active?).to be true
      expect(not_active_room.active?).to be false
    end
  end

end
