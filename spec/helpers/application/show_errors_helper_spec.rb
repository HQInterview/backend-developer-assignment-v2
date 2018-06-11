require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do

  describe "#show_errors" do
    context "when model doesn't have any errors"
    it "should return nil" do
      user = create :user
      expect(helper.show_errors(user)).to eq nil
    end
  end

  context "when model has errors" do
    it "should return html tags" do
      user = User.new email: "not.an.email", password: "sort"
      user.save
      expect(helper.show_errors(user)).to eq "<div class='error_explanation'><h4>2 errors prohibited this model from being saved:</h4><ul><li>Email is invalid</li><li>Password is too short (minimum is 8 characters)</li></ul></div>"
    end
  end

end
