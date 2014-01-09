#!/usr/bin/env rake
require "bundler/gem_tasks"

begin
  require 'rspec/core/rake_task'

  desc "Run tests"
  RSpec::Core::RakeTask.new do |t|
    t.ruby_opts = %w[-w]
  end

  task default: %w[spec]

rescue LoadError
  puts "RSpec Unavailable"
end
