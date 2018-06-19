class BidsController < ApplicationController

  def create
    bid = Bid.new bid_params.merge(user_id: current_user.id, user_email: current_user.email)
    result = Bid.post_bid(bid, current_user)
    if result[:exception].present?
      redirect_to result[:redirection_path], alert: result[:exception]
    else
      if bid.accepted
        redirect_to result[:redirection_path], notice: "Bid posted with status ACCEPTED"
      else
        redirect_to result[:redirection_path], alert: "Bid posted with status REJECTED"
      end
    end
  end

private
  def bid_params
    params.require(:bid).permit(:amount, :room_id)
  end
end
