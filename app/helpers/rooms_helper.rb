module RoomsHelper

  # show if the bid amount in the table if it'sis greater than zero
  def show_if_positive(winner_bid)
    winner_bid.positive? ? bath_currency_for(winner_bid) : ""
  end

  # render either the highest bid or the minimal bid
  def render_highest_bid_for(room)
    if room.has_any_winner?
      "<h4>The highest bid is <strong>#{bath_currency_for(room.winner_bid)}</strong></h4><h5> posted by <span class='text-blue'>#{room.winner_user_email}</span></h5>".html_safe
    else
      "<h4>The minimal bid is <strong>#{bath_currency_for(room.minimal_bid)}</strong></h4>".html_safe
    end
  end

  # render the remaining time or a message for expired auction
  def render_remaining_time(expiration_time)
    if expiration_time < Time.now
      "<h4></br><span id='expiration_status'>This Auction has </span><span class='text-blue'>FINISHED</span></h4>".html_safe
    else
      "<h4></br><span id='expiration_status'>Remaining Time: </span><span class='expiration-time-room text-green hidden'>#{time_in_milliseconds(expiration_time)}</span></h4>".html_safe
    end
  end

  # format bid.created_at timestamp
  def format_time(time)
    time.strftime("%d/%m/%Y %H:%M:%S")
  end

  # render the status of the bid (accepted/rejected)
  def render_bid_status(accepted)
    if accepted
      status = "ACCEPTED"
      color_class = "text-green"
    else
      status = "REJECTED"
      color_class = "text-red"
    end
    "<span class='#{color_class}'>#{status}</span>".html_safe
  end

  # show amount with Bath currency symbol
  def bath_currency_for(amount)
    "#{amount} &#3647".html_safe
  end

end
