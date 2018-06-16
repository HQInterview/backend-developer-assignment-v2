require "rails_helper"

RSpec.describe Room, type: :model do

  it "should have a CONSTANT named ROOM_TYPE" do
    expect(Room::ROOM_TYPE).to eq ["Penthouse", "Suite", "Deluxe Room"]
    expect(Room::ROOM_TYPE.frozen?).to be true
  end

  it "should have a CONSTANT named MINIMAL_INCREASE_BID" do
    expect(Room::MINIMAL_INCREASE_BID).to eq 1.05
    expect(Room::MINIMAL_INCREASE_BID.frozen?).to be true
  end

  it { should have_many(:bids).dependent(:destroy) }

  it { should validate_presence_of :name }
  it { should validate_presence_of :expires_at }
  it { should validate_presence_of :minimal_bid }

end
