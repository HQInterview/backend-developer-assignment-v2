require "rails_helper"

RSpec.describe Bid, type: :model do

  it { should validate_presence_of :amount }
  it { should validate_presence_of :user_email }
  it { should validate_numericality_of(:amount).only_integer.with_message("must be a number without decimals") }

  it { should belong_to(:user).counter_cache(:amount_of_bids) }
  it { should belong_to(:room).counter_cache(:amount_of_bids) }
end
