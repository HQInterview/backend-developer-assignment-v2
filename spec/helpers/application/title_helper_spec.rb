require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do
  describe "#title" do
    it "should set the content_for the key :title" do
      page_title = "page title"
      title page_title
      expect(content_for(:title)).to eq page_title
    end
  end
end
