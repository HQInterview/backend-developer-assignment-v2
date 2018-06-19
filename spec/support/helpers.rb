module Helpers

  # Login as the given user filling the login form
  def login_as_user(user=create(:user), options={ })
    password = options[:password] || "password"
    user.activate! unless user.active?
    visit root_path
    click_link "Login"
    fill_in "email", :with => user.email
    fill_in "password", :with => password
    click_button "login_user"
  end

  # access to view_context in tests
  def view_context
    ActionView::Base.new
  end

  # use url_helpers in tests
  def url_helpers
    Rails.application.routes.url_helpers
  end

end
