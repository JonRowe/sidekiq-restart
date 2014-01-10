require 'rack/test'
require 'logger'

describe "integrating with sidekiq web", type: :integration do
  include Rack::Test::Methods

  before :all do
    require 'sidekiq/restart'
    require 'sidekiq/testing'
    Sidekiq.logger = Logger.new(nil)
    Sidekiq::Testing.disable!
  end

  let(:app) do
    Sidekiq::Web
  end

  it "overrides the workers index" do
    get '/workers'

    expect(last_response).to be_ok
    expect(last_response.body).to match '<th>Controls</th>'
  end

  context "when there are stuck workers" do
    before do
      hash = { queue: 'test', payload: { class: Class, args: [], queue: 'test' }, run_at: Time.now.to_i }
      Sidekiq.redis do |conn|
        conn.del 'queue:test'
        conn.sadd('workers', 'my_id')
        conn.set("worker:my_id:started", Time.now.to_s)
        conn.set("worker:my_id", Sidekiq.dump_json(hash))
      end
    end

    it "allows the developer to restart workers" do
      get '/workers'

      expect(last_response).to be_ok
      expect(last_response.body).to match(
        %r%<form action="/workers/my_id" [^>]*>.*<button[^>]*>Restart</button>.*</form>%m
      )
    end

    it "will restart a stuck job" do
      delete "/workers/my_id"
      expect(last_response).to be_redirect
      expect(last_response.location).to eq 'http://example.org/workers'
      Sidekiq.redis do |conn|
        expect(conn.llen('queue:test')).to eq 1
      end
    end
  end

  context "when there are no stuck workers" do
    it "is idemoptent against non existant jobs" do
      delete "/workers/my_id"
      expect(last_response).to be_redirect
      expect(last_response.location).to eq 'http://example.org/workers'
    end
  end
end
