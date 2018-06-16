require "rails_helper"

include RoomsHelper

RSpec.describe Bid, type: :model do

  describe "#post_bid" do

    context "when an exception is raised" do
      it "should not post the bid and return the exception error" do
        user = create :user
        new_bid = Bid.new amount: 1000, user_id: user.id, user_email: user.email, room_id: 1
        expect(Room).to receive(:where).with(id: 1).and_raise(Exception.new("Exception raised"))
        expect(Room.count).to be 0
        expect(Bid.count).to be 0

        result = Bid.post_bid new_bid, user
        expect(result[:exception]).to eq "Exception raised"
        expect(result[:redirection_path]).to eq url_helpers.rooms_path
        expect(Bid.count).to be 0
      end
    end

    context "when room auction cannot be found" do
      it "should not post the bid and return the error" do
        user = create :user
        new_bid = Bid.new amount: 1000, user_id: user.id, user_email: user.email, room_id: 1
        expect(Room.count).to be 0
        expect(Bid.count).to be 0

        result = Bid.post_bid new_bid, user
        expect(result[:exception]).to eq "Bid cannot be posted cause the room acution doesn't exist"
        expect(result[:redirection_path]).to eq url_helpers.rooms_path
        expect(Bid.count).to be 0
      end
    end

    context "when bid amount is not a number" do
      it "should post the bid as REJECTED" do
        user = create :user
        room = create :room
        new_bid = Bid.new amount: "not a number", user_id: user.id, user_email: user.email, room_id: room.id
        expect(Bid.count).to be 0

        result = Bid.post_bid new_bid, user
        expect(result[:exception]).to be nil
        expect(result[:redirection_path]).to eq url_helpers.room_path(room)
        expect(Bid.count).to be 1
        bid = Bid.last
        expect(bid.accepted).to be false
        expect(bid.amount).to be 0
        expect(bid.rejection_cause).to eq "Amount must be a number without decimals"
      end
    end

    context "when bid amount contains decimals" do
      it "should post the bid as REJECTED" do
        user = create :user
        room = create :room
        new_bid = Bid.new amount: 1000.5, user_id: user.id, user_email: user.email, room_id: room.id
        expect(Bid.count).to be 0

        result = Bid.post_bid new_bid, user
        expect(result[:exception]).to be nil
        expect(result[:redirection_path]).to eq url_helpers.room_path(room)
        expect(Bid.count).to be 1
        bid = Bid.last
        expect(bid.accepted).to be false
        expect(bid.amount).to be 0
        expect(bid.rejection_cause).to eq "Amount must be a number without decimals"
      end
    end

    context "when the room auction is finished" do
      it "should post the bid as REJECTED" do
        user = create :user
        room = create :room, expires_at: 1.second.ago
        new_bid = Bid.new amount: room.minimal_allowed_bid, user_id: user.id, user_email: user.email, room_id: room.id
        expect(Bid.count).to be 0

        result = Bid.post_bid new_bid, user
        expect(result[:exception]).to be nil
        expect(result[:redirection_path]).to eq url_helpers.room_path(room)
        expect(Bid.count).to be 1
        bid = Bid.last
        expect(bid.accepted).to be false
        expect(bid.amount).to be new_bid.amount
        expect(bid.rejection_cause).to eq "Bid posted out of time"
      end
    end

    context "when new bid is not a winner" do
      it "should post the bid as REJECTED" do
        user = create :user
        room = create :room
        new_bid = Bid.new amount: room.minimal_allowed_bid - 1, user_id: user.id, user_email: user.email, room_id: room.id
        expect(Bid.count).to be 0

        result = Bid.post_bid new_bid, user
        expect(result[:exception]).to be nil
        expect(result[:redirection_path]).to eq url_helpers.room_path(room)
        expect(Bid.count).to be 1
        bid = Bid.last
        expect(bid.accepted).to be false
        expect(bid.amount).to be new_bid.amount
        expect(bid.rejection_cause).to eq "Bid is not >= #{bath_currency_for(room.minimal_allowed_bid)}"
      end
    end

    context "when new bid is a winner" do
      it "should post the bid as ACCEPTED and update the room auction accordingly" do
        user = create :user
        room = create :room, expires_at: 5.minutes.from_now
        old_room_user_email = room.winner_user_email
        old_room_minimal_bid = room.minimal_bid
        old_room_winner_bid = room.winner_bid
        old_room_expireation_time = room.expires_at
        new_bid = Bid.new amount: room.minimal_allowed_bid, user_id: user.id, user_email: user.email, room_id: room.id
        expect(Bid.count).to be 0

        result = Bid.post_bid new_bid, user
        expect(result[:exception]).to be nil
        expect(result[:redirection_path]).to eq url_helpers.room_path(room)
        expect(Bid.count).to be 1
        bid = Bid.last
        expect(bid.accepted).to be true
        expect(bid.amount).to be new_bid.amount
        expect(bid.rejection_cause).to eq nil
        room.reload
        expect(room.winner_user_email).to eq user.email
        expect(room.minimal_bid).to eq old_room_minimal_bid
        expect(room.winner_bid).to eq bid.amount
        expect(room.expires_at).to eq old_room_expireation_time        
        expect(room.winner_user_email).to_not eq old_room_user_email
        expect(room.winner_bid).to_not eq old_room_winner_bid
      end
    end

    context "when new bid is a winner and remaining time for room is less than 1 minute" do
      it "should post the bid as ACCEPTED and update the room auction accordingly" do
        user = create :user
        room = create :room, expires_at: 59.seconds.from_now
        old_room_user_email = room.winner_user_email
        old_room_minimal_bid = room.minimal_bid
        old_room_winner_bid = room.winner_bid
        old_room_expireation_time = room.expires_at
        new_bid = Bid.new amount: room.minimal_allowed_bid, user_id: user.id, user_email: user.email, room_id: room.id
        expect(Bid.count).to be 0

        result = Bid.post_bid new_bid, user
        expect(result[:exception]).to be nil
        expect(result[:redirection_path]).to eq url_helpers.room_path(room)
        expect(Bid.count).to be 1
        bid = Bid.last
        expect(bid.accepted).to be true
        expect(bid.amount).to be new_bid.amount
        expect(bid.rejection_cause).to eq nil
        room.reload
        expect(room.winner_user_email).to eq user.email
        expect(room.minimal_bid).to eq old_room_minimal_bid
        expect(room.winner_bid).to eq bid.amount
        expect(room.expires_at).to eq old_room_expireation_time + 1.minute       
        expect(room.winner_user_email).to_not eq old_room_user_email
        expect(room.winner_bid).to_not eq old_room_winner_bid
        expect(room.expires_at).to_not eq old_room_expireation_time
      end
    end

  end
end
