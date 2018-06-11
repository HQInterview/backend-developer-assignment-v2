require "rails_helper"

RSpec.feature User, type: :feature do
  describe "#logged_in?" do
    it "should return true if the user is loggedin" do
      user = create :user
      expect(user.logged_in?).to be false
      login_as_user user
      user.reload
      expect(user.logged_in?).to be true
    end
  end
end
