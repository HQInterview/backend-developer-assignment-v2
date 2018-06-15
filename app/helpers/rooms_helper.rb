module RoomsHelper

  # show if the bid amount in the table if it'sis greater than zero
  def show_if_positive(winner_bid)
    winner_bid.positive? ? bath_currency_for(winner_bid) : ""
  end
  end

end
