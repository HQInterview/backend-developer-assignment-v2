# == Schema Information
#
# Table name: bids
#
#  id              :integer          not null, primary key
#  amount          :integer          not null
#  accepted        :boolean          default(TRUE)
#  rejection_cause :string
#  user_email      :string           not null
#  user_id         :integer
#  room_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Bid < ApplicationRecord

  # contants
  #--------------------------------------------------------------
  BIDS_PER_PAGE = 10.freeze

  # associations
  #--------------------------------------------------------------
  belongs_to :user, counter_cache: :amount_of_bids
  belongs_to :room, counter_cache: :amount_of_bids

  # validations
  #--------------------------------------------------------------
  validates_presence_of :amount
  validates_presence_of :user_email
  validates :amount, numericality: { only_integer: true, message: "must be a number without decimals" }

  # scopes
  #--------------------------------------------------------------
  default_scope -> { order(created_at: :desc) }

  # callbacks
  #--------------------------------------------------------------
  after_create :send_pusher_event

  # instance methods
  #--------------------------------------------------------------

  # send an event to Pusher (real time update room auction)
  def send_pusher_event
    pusher_client.trigger("auctions", "new_bid_in_room_#{self.room_id}", self.to_json)
  end

  # class methods
  #--------------------------------------------------------------

  # post a bid in a room
  def self.post_bid(bid, user)
    url_helpers = Rails.application.routes.url_helpers
    result = {redirection_path: url_helpers.rooms_path}
    begin
      if Room.where(id: bid.room_id).empty?
        result[:exception] = "Bid cannot be posted cause the room acution doesn't exist"
        return
      end
      room = Room.find(bid.room_id)
      result[:redirection_path] = url_helpers.room_path(room)
      if bid.invalid? # check if the bid is not valid (not a number, a float value...)
        bid.accepted = false
        bid.amount = 0
        bid.rejection_cause = bid.errors.full_messages.join(", ")
      elsif Time.now >= room.expires_at
        bid.accepted = false
        bid.rejection_cause = "Bid posted out of time" unless bid.accepted
      else
        bid.accepted = room.is_a_winner?(bid.amount)
        bid_not_winner_message = "Bid is not >= #{ApplicationController.helpers.bath_currency_for(room.minimal_allowed_bid)}"
        bid.rejection_cause = bid_not_winner_message unless bid.accepted
      end
      bid.save
      room.set_new_winner!(bid, user) if bid.accepted
    rescue Exception => error
      result[:exception] = error.message
    ensure
      return result
    end
  end

end
