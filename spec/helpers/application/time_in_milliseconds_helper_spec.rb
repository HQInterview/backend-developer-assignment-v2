require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do
  describe "#time_in_milliseconds" do
    it "should return the time in milliseconds from a given Time object" do
      time = Time.now
      milliseconds = (time.to_f * 1000).to_i
      expect(time_in_milliseconds(time)).to eq milliseconds
    end
  end
end
