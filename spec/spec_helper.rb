# frozen_string_literal: true

require 'rspec/hanami'

# Require this file for unit tests
ENV['HANAMI_ENV'] ||= 'test'

require_relative '../config/environment'
Hanami.boot
Hanami::Utils.require!("#{__dir__}/support")

RSpec.configure do |config|
  config.include RSpec::Hanami::Matchers

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.disable_monkey_patching!

  # Show 10 slowest example groups at the end
  # of the tests
  # config.profile_examples = 10
end
