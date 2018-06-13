require "rails_helper"

RSpec.describe Room, type: :model do

  describe "#is_a_winner?" do
    it "should return true if the bid is a winner" do
      room = create :room, winner_bid: 1000
      winner_bid = create :bid, amount: room.winner_bid * Room::MINIMAL_INCREASE_BID
      not_winner_bid = create :bid, amount: (room.winner_bid * Room::MINIMAL_INCREASE_BID) - 1

      expect(room.is_a_winner?(not_winner_bid.amount)).to be false
      expect(room.is_a_winner?(winner_bid.amount)).to be true
    end
  end

end
