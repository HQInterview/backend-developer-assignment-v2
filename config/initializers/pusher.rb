require "pusher"

def pusher_config?
  [
    ENV["PUSHER_APP_ID"].present?,
    ENV["PUSHER_KEY"].present?,
    ENV["PUSHER_SECRET"].present?
  ].all?
end

if pusher_config?
  Pusher.app_id = ENV["PUSHER_APP_ID"]
  Pusher.key = ENV["PUSHER_KEY"]
  Pusher.secret = ENV["PUSHER_SECRET"]
  Pusher.logger = Rails.logger
  Pusher.encrypted = true
else
  Rails.logger.error "Pusher is not configured. Please set up config/application.yml"
end

def pusher_client
  config = {
    key: Pusher.key,
    app_id: Pusher.app_id,
    secret: Pusher.secret
  }

  if Rails.env.test?
    require "pusher-fake/support/base"
    return Pusher::Client.new(config.merge(PusherFake.configuration.web_options))
  else
    return Pusher::Client.new(config)
  end
end
