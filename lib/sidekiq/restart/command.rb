module Sidekiq
  module Restart
    class Command

      def initialize sidekiq
        @sidekiq = sidekiq
      end

      def run id
        @sidekiq.redis do |conn|
          payload = conn.get("worker:#{id}")
          if payload
            msg = @sidekiq.load_json(payload)['payload']
            Sidekiq::Client.push msg

            # cleanup redis details about the worker
            conn.srem("workers", id)
            conn.del("worker:#{id}")
            conn.del("worker:#{id}:started")
          end
        end
      end

    end
  end
end
