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

  # scopes
  #--------------------------------------------------------------
  default_scope -> { order(created_at: :desc) }

  # instance methods
  #--------------------------------------------------------------

  # class methods
  #--------------------------------------------------------------

end
