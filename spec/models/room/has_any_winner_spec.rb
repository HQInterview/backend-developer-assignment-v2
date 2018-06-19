require "rails_helper"

RSpec.describe Room, type: :model do

  describe "#has_any_winner?" do
    it "should return true if the rooms has any winner bid" do
      room = create :room
      expect(room.winner_bid).to be 0
      expect(room.has_any_winner?).to be false

      room.update_attributes winner_bid: 1
      expect(room.has_any_winner?).to be true
    end
  end

end
