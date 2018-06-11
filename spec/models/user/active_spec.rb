require "rails_helper"

RSpec.describe User, type: :model do
  describe "#active?" do
    it "should return true if the user is active" do
      user = create :user, activation_state: nil
      expect(user).to_not be_active
      user.activate!
      expect(user).to be_active
    end
  end
end
