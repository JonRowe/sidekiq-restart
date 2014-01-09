#loaded by .rspec

RSpec.configure do |config|
  config.register_ordering :global do |examples|
    unit, integration = examples.partition { |example| example.metadata[:type] != :integration }
    unit.shuffle + integration.shuffle
  end
end
