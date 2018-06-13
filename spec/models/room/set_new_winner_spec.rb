require "rails_helper"

RSpec.describe Room, type: :model do

  describe "#set_new_winner" do
    it "should update room details for the new winner" do
      room = create :room
      old_winner_bid = room.winner_bid
      old_winner_bid_id = room.winner_bid_id
      old_winner_user_email = room.winner_user_email

      # there was not winner bid yet
      new_bid = create :bid, room: room
      expect { room.set_new_winner!(new_bid, new_bid.user) }.to change(room, :winner_bid).from(old_winner_bid).to(new_bid.amount)
        .and change(room, :winner_bid_id).from(old_winner_bid_id).to(new_bid.id)
        .and change(room, :winner_user_email).from(old_winner_user_email).to(new_bid.user.email)

      ## there was already an old winner bid
      new_bid = create :bid, room: room
      old_winner_bid = room.winner_bid
      old_winner_bid_id = room.winner_bid_id
      old_winner_user_email = room.winner_user_email
      expect { room.set_new_winner!(new_bid, new_bid.user) }.to change(room, :winner_bid).from(old_winner_bid).to(new_bid.amount)
        .and change(room, :winner_bid_id).from(old_winner_bid_id).to(new_bid.id)
        .and change(room, :winner_user_email).from(old_winner_user_email).to(new_bid.user.email)
    end
  end

  context "when there is still more than 1 minute to place bids" do
    it "should not update the expiration time" do
      room = create :room, expires_at: 5.minutes.from_now
      old_expiration_time = room.expires_at
      new_bid = create :bid, room: room

      room.set_new_winner!(new_bid, new_bid.user)

      expect(room.expires_at).to eq old_expiration_time
    end
  end

  context "when there is still more than 1 minute to place bids" do
    it "should extend the expiration time by 1 minute" do
      room = create :room, expires_at: 50.seconds.from_now
      old_expiration_time = room.expires_at
      new_bid = create :bid, room: room

      room.set_new_winner!(new_bid, new_bid.user)

      expect(room.expires_at).to_not eq old_expiration_time
      expect(room.expires_at).to eq old_expiration_time + 1.minute
    end
  end

end
