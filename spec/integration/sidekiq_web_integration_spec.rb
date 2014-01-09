require 'rack/test'
require 'sidekiq/restart'
require 'sidekiq/testing'

describe "integrating with sidekiq web", type: :integration do
  include Rack::Test::Methods

  let(:app) do
    Sidekiq::Web
  end

  it "overrides the workers index" do
    get '/workers'

    expect(last_response).to be_ok
    expect(last_response.body).to match '<th>Controls</th>'
  end
end
