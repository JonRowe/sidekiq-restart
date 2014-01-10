require 'sidekiq/restart/command'

describe "Sidekiq::Restart::Command" do
  let(:sidekiq) { double "Sidekiq" }
  let(:command) { Sidekiq::Restart::Command.new sidekiq }

  describe '#run' do
    let(:id)    { "my_id" }

    before do
      allow(sidekiq).to receive(:redis).and_yield(redis)
    end

    context "theres a worker with id" do
      let(:redis) { instance_double "Redis", get: json, del: nil, srem: nil }
      let(:data)  { { 'payload' => msg } }; let(:json) { double }; let(:msg) { double }

      before do
        class_double("Sidekiq::Client", push: nil).as_stubbed_const
        allow(sidekiq).to receive(:load_json).and_return(data)
      end

      it 'uses sidekiqs redis instance' do
        expect(sidekiq).to receive(:redis).and_yield(redis)
        command.run id
      end

      it 'retrieves the job details' do
        expect(redis).to receive(:get).with("worker:my_id")
        expect(sidekiq).to receive(:load_json).with(json)
        command.run id
      end

      it 'requeues the job' do
        expect(Sidekiq::Client).to receive(:push).with(msg)
        command.run id
      end

      it 'cleans up the old worker details' do
        expect(redis).to receive(:srem).with("workers", id)
        expect(redis).to receive(:del).with("worker:my_id")
        expect(redis).to receive(:del).with("worker:my_id:started")
        command.run id
      end
    end

    context "no such worker exists" do
      let(:redis) { instance_double "Redis", get: nil }

      it 'uses sidekiqs redis instance' do
        expect(sidekiq).to receive(:redis).and_yield(redis)
        command.run id
      end
    end
  end
end
