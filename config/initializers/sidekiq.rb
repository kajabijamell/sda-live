Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('REDISCLOUD_URL') { 'redis://localhost:6379/1' } }
end