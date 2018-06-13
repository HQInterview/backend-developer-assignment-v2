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
  scope :active, -> { where("expires_at > ?", Time.now) }
  scope :by_remaining_time, -> { order(expires_at: :asc) }

  # instance methods
  #--------------------------------------------------------------

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

  # has room any winner bid?
  def has_any_winner?
    self.winner_bid.positive?
  end

  # is bid a winner?
  def is_a_winner?(bid_amount)
    return true if self.winner_bid.zero?
    bid_amount >= self.winner_bid * MINIMAL_INCREASE_BID
  end

  # publish some sample rooms for auctions
  def self.create_sample_rooms!
    return unless self.active.empty?
    require "faker"
    Room.destroy_all
    Faker::Number.between(10, 20).times do
      new_room = {
        name: "#{ROOM_TYPE.sample} in Hotel #{Faker::Company.name} (#{Faker::Address.city})",
        expires_at: rand(5.minutes.from_now..10.minutes.from_now),
        minimal_bid: Faker::Number.between(10, 50) * 100
      }
      self.create new_room
    end
  end

end
