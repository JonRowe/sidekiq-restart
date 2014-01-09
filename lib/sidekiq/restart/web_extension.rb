module Sidekiq
  module Restart
    module WebExtension

      def self.registered(app)
        app.use Rack::MethodOverride

        app.helpers do
          def find_template(sidekiq_views, name, engine, &block)
            view_path = File.join(File.expand_path("../../../../web", __FILE__), "views")
            super(view_path, name, engine, &block)
            super(sidekiq_views, name, engine, &block)
          end
        end

        app.delete "/workers/:id" do |id|
          redirect "#{root_path}workers", 301
        end
      end
    end
  end
end
