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

  # constants
  #--------------------------------------------------------------

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

  # instance methods
  #--------------------------------------------------------------

  # class methods
  #--------------------------------------------------------------

  # post a bid in a room
  def self.post_bid(bid, user)
    result = {}
    begin
      room = Room.find(bid.room_id)
      result[:redirection_path] = Rails.application.routes.url_helpers.room_path(room)
      if bid.valid?
        # check if bid is posted on time
        if Time.now >= room.expires_at
          bid.accepted = false
          bid.rejection_cause = "Bid posted out of time" unless bid.accepted
          bid.save
          return
        end
        # check if bid is a new winner
        bid.accepted = room.is_a_winner?(bid.amount)
        bid.rejection_cause = "Bid is not >= #{room.minimal_allowed_bid}" unless bid.accepted
      else
        # if the bid posted is not valid (not a number, a float value...)
        bid.accepted = false
        bid.amount = 0
        bid.rejection_cause = bid.errors.full_messages.join(", ")
      end
      bid.save
      room.set_new_winner!(bid, user) if bid.accepted
    rescue Exception => error
      bid.accepted = false
      bid.rejection_cause = error.message
      bid.save
      result[:exception] = true
    ensure
      return result
    end
  end

end
