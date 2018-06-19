require "rails_helper"

RSpec.describe RoomsHelper, type: :helper do
  describe "#show_if_positive" do
    it "should return the amount value if it's not zero" do
      zero = 0
      non_zero = 1
      expect(show_if_positive(zero)).to eq ""
      expect(show_if_positive(non_zero)).to eq bath_currency_for(non_zero)
    end
  end
end
