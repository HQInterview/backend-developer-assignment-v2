module Helpers

  # access to view_context in tests
  def view_context
    ActionView::Base.new
  end

  # use url_helpers in tests
  def url_helpers
    Rails.application.routes.url_helpers
  end

end
