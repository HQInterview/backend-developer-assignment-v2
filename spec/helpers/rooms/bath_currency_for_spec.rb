require "rails_helper"

RSpec.describe RoomsHelper, type: :helper do
  describe "#bath_currency_for" do
    it "should show amount with Bath currency symbol" do
      amount = 1000
      expect(bath_currency_for(amount)).to eq "#{amount} &#3647".html_safe
    end
  end
end
