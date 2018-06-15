require "rails_helper"
include ApplicationHelper

RSpec.describe RoomsHelper, type: :helper do
  describe "#render_remaining_time" do
    it "render show the remaining time or a message for expired auctiond" do
      acive_room = create :room, expires_at: 5.minutes.from_now
      expired_room = create :room, expires_at: 1.minutes.ago

      expect(render_remaining_time(acive_room.expires_at)).to eq "<h4></br><span id='expiration_status'>Remaining Time: </span><span class='expiration-time-room text-green hidden'>#{time_in_milliseconds(acive_room.expires_at)}</span></h4>".html_safe
      expect(render_remaining_time(expired_room.expires_at)).to eq "<h4></br><span id='expiration_status'>This Auction has </span><span class='text-blue'>FINISHED</span></h4>".html_safe
    end
  end
end
