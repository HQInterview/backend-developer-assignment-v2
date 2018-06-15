require "rails_helper"

RSpec.describe RoomsHelper, type: :helper do
  describe "#format_time" do
    it "should format the provided timestamp" do
      time = Time.now

      expect(format_time(time)).to eq time.strftime("%d/%m/%Y %H:%M:%S")
    end
  end
end
