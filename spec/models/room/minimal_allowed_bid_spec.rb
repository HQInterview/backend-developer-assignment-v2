require "rails_helper"

RSpec.describe Room, type: :model do

  describe "#minimal_allowed_bid?" do
    it "should return true if the bid is a winner" do
      bidded_room = create :room, winner_bid: 1000
      unbidded_room = create :room, minimal_bid: 1000

      expect(bidded_room.minimal_allowed_bid).to be (bidded_room.winner_bid * Room::MINIMAL_INCREASE_BID).to_i
      expect(bidded_room.minimal_allowed_bid).to be 1050
      expect(unbidded_room.minimal_allowed_bid).to be unbidded_room.minimal_bid
      expect(unbidded_room.minimal_allowed_bid).to be 1000
    end
  end

end
