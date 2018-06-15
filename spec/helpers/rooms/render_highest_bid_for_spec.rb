require "rails_helper"

RSpec.describe RoomsHelper, type: :helper do
  describe "#render_highest_bid_for" do
    it "should render either the higest bid or the minimal bid" do
      room_with_bids = create :room, winner_bid: 2000, winner_user_email: "winner@email.com"
      room_without_bids = create :room, minimal_bid: 1000

      result = "<h4>The highest bid is <strong>#{bath_currency_for(room_with_bids.winner_bid)}</strong></h4>"
      result << "<h5> posted by <span class='text-blue'>#{room_with_bids.winner_user_email}</span></h5>"
      expect(render_highest_bid_for(room_with_bids)).to eq result.html_safe
      result =  "<h4>The highest bid is <strong>#{bath_currency_for(2000)}</strong></h4>"
      result << "<h5> posted by <span class='text-blue'>winner@email.com</span></h5>"
      expect(render_highest_bid_for(room_with_bids)).to eq result.html_safe
      result = "<h4>The minimal bid is <strong>#{bath_currency_for(room_without_bids.minimal_bid)}</strong></h4>"
      expect(render_highest_bid_for(room_without_bids)).to eq result.html_safe
      result = "<h4>The minimal bid is <strong>#{bath_currency_for(1000)}</strong></h4>"
      expect(render_highest_bid_for(room_without_bids)).to eq result.html_safe
    end
  end
end
