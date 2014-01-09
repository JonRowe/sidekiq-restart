require "sidekiq/restart/version"
require "sidekiq/restart/web_extension"

begin
  require "sinatra"
  require "sidekiq/web"

  Sidekiq::Web.register Sidekiq::Restart::WebExtension
rescue LoadError
  # client-only usage
end
