require "rails_helper"

RSpec.describe User, type: :model do
  describe "#resend_activation_email!" do
    it "should call the sorcery method send_activation_needed_email! on the user" do
      user = create :user
      expect(user).to receive(:send_activation_needed_email!).exactly(:once)
      user.resend_activation_email!
    end
  end
end
