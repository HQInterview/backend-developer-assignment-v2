# == Schema Information
#
# Table name: rooms
#
#  id                :integer          not null, primary key
#  name              :string           not null
#  expires_at        :datetime         not null
#  minimal_bid       :integer          not null
#  winner_bid        :integer          default(0)
#  winner_bid_id     :integer
#  winner_user_email :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  amount_of_bids    :integer          default(0)
#

class Room < ApplicationRecord

  # constants
  #--------------------------------------------------------------
  ROOM_TYPE = ["Penthouse", "Suite", "Deluxe Room"].freeze
  MINIMAL_INCREASE_BID = 1.05.freeze

  # associations
  #--------------------------------------------------------------
  has_many :bids, dependent: :destroy

  # validations
  #--------------------------------------------------------------
  validates_presence_of :name
  validates_presence_of :expires_at
  validates_presence_of :minimal_bid

  # scopes
  #--------------------------------------------------------------
  scope :active, -> { where("expires_at > ?", Time.now) }
  scope :by_remaining_time, -> { order(expires_at: :asc) }

  # instance methods
  #--------------------------------------------------------------

  # is room active to accept bids?
  def active?
    self.expires_at > Time.now
  end

  # has room any winner bid?
  def has_any_winner?
    self.winner_bid.positive?
  end

  # is bid amount a winner?
  def is_a_winner?(bid_amount)
    bid_amount >= self.minimal_allowed_bid
  end

  # return the minimal allowed bid
  def minimal_allowed_bid
    if self.winner_bid.positive?
      (self.winner_bid * MINIMAL_INCREASE_BID).to_i
    else
      self.minimal_bid
    end
  end

  # update room details for the new winner
  def set_new_winner!(bid, user)
    new_attributes = {
      winner_bid: bid.amount,
      winner_bid_id: bid.id,
      winner_user_email: user.email
    }
    if (self.expires_at - bid.created_at) < 1.minute
      new_attributes[:expires_at] = self.expires_at + 1.minute
    end
    self.update_attributes new_attributes
  end

  # class methods
  #--------------------------------------------------------------

  # publish some sample rooms for auctions
  def self.create_sample_rooms!
    return unless self.active.empty?
    require "faker"
    Room.destroy_all
    Faker::Number.between(10, 20).times do
      new_room = {
        name: "#{ROOM_TYPE.sample} in Hotel #{Faker::Company.name} (#{Faker::Address.city})",
        expires_at: rand(20.minutes.from_now..30.minutes.from_now),
        minimal_bid: Faker::Number.between(10, 50) * 100
      }
      room = self.create new_room
      Faker::Number.between(5, 10).times do
        amount = Faker::Number.between(10, 50) * 100
        new_bid = {
          amount: amount,
          accepted: room.is_a_winner?(amount) ? true : false,
          user_email: Faker::Internet.email,
          user_id: 1
        }
        new_bid[:rejection_cause] = "Bid is not >= #{room.minimal_allowed_bid}" unless new_bid[:accepted]
        bid = room.bids.create new_bid
        room.update_attributes winner_bid: amount, winner_bid_id: bid.id, winner_user_email: new_bid[:user_email] if new_bid[:accepted]
      end
    end
  end

end
