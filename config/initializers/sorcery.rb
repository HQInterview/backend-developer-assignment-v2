Rails.application.config.sorcery.submodules = [:user_activation, :remember_me, :reset_password, :activity_logging]

Rails.application.config.sorcery.configure do |config|

  config.user_config do |user|
    user.username_attribute_names                     = [:email]

    user.user_activation_mailer                       = UserMailer
    user.activation_token_attribute_name              = :activation_code
    user.activation_token_expires_at_attribute_name   = :activation_code_expires_at

    user.reset_password_mailer                        = UserMailer
    user.reset_password_expiration_period             = 20.minutes
    user.reset_password_time_between_emails           = nil
  end

  config.user_class = User
end
