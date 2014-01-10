require "sidekiq/restart/version"
require "sidekiq/restart/command"
require "sidekiq/restart/web_extension"

begin
  require "sinatra"
  require "sidekiq/web"

  Sidekiq::Web.register Sidekiq::Restart::WebExtension
rescue LoadError
  # client-only usage
end

module Sidekiq
  module Restart
    module_function

    def worker id
      Command.new(Sidekiq).run id
    end
  end
end
