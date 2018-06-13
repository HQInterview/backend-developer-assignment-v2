require "rails_helper"

RSpec.describe Room, type: :model do

  describe "#create_sample_rooms!" do

    context "when there isn't any active room" do

      it "should delete all the old rooms" do
        create :room, expires_at: 1.minute.ago
        create :room, expires_at: 1.second.ago
        expect(Room.count).to be 2
        expect(Room.active.size).to be 0

        expect(Room).to receive(:destroy_all).exactly(:once)

        Room.create_sample_rooms!
      end

      it "should create some sample rooms available to accept bids" do
        create :room, expires_at: 1.second.ago
        expect(Room.count).to be 1
        expect(Room.active.size).to be 0

        Room.create_sample_rooms!
        expect(Room.active.size).to be_between(10, 20).inclusive
      end
    end

    context "when there isn't any active room" do

      it "should do nothing" do
        room = create :room
        expect(Room.active.size).to be 1

        Room.create_sample_rooms!
        expect(Room.active.size).to be 1
        expect(Room.active.first).to eq room
      end

    end
  end
end
