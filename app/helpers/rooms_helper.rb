module RoomsHelper

  def winner_bid_cell(winner_bid)
    winner_bid.positive? ? winner_bid : ""
  end

end
