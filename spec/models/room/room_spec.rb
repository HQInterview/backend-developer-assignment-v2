require "rails_helper"

RSpec.describe Room, type: :model do

  it { should validate_presence_of :name }
  it { should validate_presence_of :expires_at }
  it { should validate_presence_of :minimal_bid }

end
