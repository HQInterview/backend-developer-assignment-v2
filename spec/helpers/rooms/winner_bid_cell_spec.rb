require "rails_helper"

RSpec.describe RoomsHelper, type: :helper do
  describe "#winner_bid_cell" do
    it "should return the correct value for the table cell (empty string if value is 0, the value instead)" do
      zero = 0
      non_zero = 1
      expect(winner_bid_cell(zero)).to eq ""
      expect(winner_bid_cell(non_zero)).to eq non_zero
    end
  end
end
