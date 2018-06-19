require "rails_helper"

RSpec.describe User, type: :model do
  describe "#password_required?" do
    it "should return true if the user was not created yet" do
      user = create :user
      new_user = User.new
      expect(user.send(:password_required?)).to be false
      expect(new_user.send(:password_required?)).to be true
    end
  end
end
