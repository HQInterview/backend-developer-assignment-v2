require "rails_helper"

RSpec.describe Bid, type: :model do

  describe "#default scope" do
    it "should return the bids in descendent order by creation time (last created first)" do
      old_bid = create :bid
      new_bid = create :bid
      expect(Bid.count).to be 2

      bids = Bid.all
      expect(bids.size).to be 2
      expect(bids.first).to eq new_bid
      expect(bids.last).to eq old_bid
    end
  end

end
