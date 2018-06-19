require "rails_helper"

RSpec.describe RoomsHelper, type: :helper do
  describe "#render_bid_status" do
    it "should render the status of the bid (accepted/rejected)" do
      accepted = true
      expect(render_bid_status(accepted)).to eq "<span class='text-green'>ACCEPTED</span>".html_safe

      accepted = false
      expect(render_bid_status(accepted)).to eq "<span class='text-red'>REJECTED</span>".html_safe
    end
  end
end
