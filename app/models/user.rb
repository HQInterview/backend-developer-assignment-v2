# == Schema Information
#
# Table name: users
#
#  id                              :integer          not null, primary key
#  email                           :string           not null
#  crypted_password                :string
#  salt                            :string
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  activation_state                :string
#  activation_code                 :string
#  activation_code_expires_at      :datetime
#  remember_me_token               :string
#  remember_me_token_expires_at    :datetime
#  reset_password_token            :string
#  reset_password_token_expires_at :datetime
#  reset_password_email_sent_at    :datetime
#  last_login_at                   :datetime
#  last_logout_at                  :datetime
#  last_activity_at                :datetime
#  last_login_from_ip_address      :string
#  failed_logins_count             :integer          default(0)
#  lock_expires_at                 :datetime
#

class User < ApplicationRecord

  # constants
  #--------------------------------------------------------------
  PASSWORD_LENGTH = 8
  EMAIL_REGEX = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/

  # authentication
  #--------------------------------------------------------------
  authenticates_with_sorcery!

  # validations
  #--------------------------------------------------------------
  validates_presence_of :email
  validates_uniqueness_of :email, case_sensitive: false
  validates_format_of :email, with: EMAIL_REGEX, multiline: true
  validates_presence_of :password, :if => :password_required?
  validates_length_of :password, minimum: PASSWORD_LENGTH, :if => :password
  validates_confirmation_of :password, message: "should match confirmation", :if => :password

  # instance methods
  #--------------------------------------------------------------

  # is user active?
  def active?
    self.activation_state == "active"
  end

  # is user logged in?
  def logged_in?
    return false if self.last_login_at.nil?
    return true if self.last_logout_at.nil?
    self.last_login_at > self.last_logout_at
  end

  # resend the activation email
  def resend_activation_email!
    self.send_activation_needed_email!
  end

  private
  # if it's a new user the password is required
  def password_required?
    new_record?
  end

end
