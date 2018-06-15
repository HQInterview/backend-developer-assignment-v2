module RoomsHelper

  # show if the bid amount in the table if it'sis greater than zero
  def show_if_positive(winner_bid)
    winner_bid.positive? ? bath_currency_for(winner_bid) : ""
  end

  # show amount with Bath currency symbol
  def bath_currency_for(amount)
    "#{amount} &#3647".html_safe
  end

end
