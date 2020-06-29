# frozen_string_literal: true

require 'rack/test'
require 'rspec'
require 'factory_bot'
require 'database_cleaner'

ENV['RACK_ENV'] = 'test'

require File.expand_path '../app.rb', __dir__

module RSpecMixin
  include Rack::Test::Methods
  def app
    Sinatra::Application
  end
end

RSpec.configure do |config|
  config.include RSpecMixin
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    DatabaseCleaner[:active_record].strategy = :transaction
    DatabaseCleaner[:active_record].clean_with(:truncation)
  end

  config.before do |_spec|
    DatabaseCleaner[:active_record].start
  end

  config.after do |_spec|
    DatabaseCleaner[:active_record].clean
  end
end
