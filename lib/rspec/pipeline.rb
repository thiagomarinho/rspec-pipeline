# frozen_string_literal: true

require_relative 'pipeline/version'
require 'pipeline/matcher'
require 'pipeline/helper'
require 'pipeline/context'
require 'pipeline/fixture_loader'

module Rspec::Pipeline
  class Error < StandardError; end
end

RSpec.configure do |config|
  config.alias_example_group_to :pipeline, detailed: true, type: :pipeline, include_shared: true
  config.alias_example_group_to :stage, detailed: true, type: :stage, include_shared: true
  config.alias_example_group_to :job, detailed: true, type: :job, include_shared: true
  config.alias_example_group_to :step, detailed: true, type: :step, include_shared: true

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.add_setting :setup_fixtures, default: true
  config.add_setting :fixtures_repos, default: []

  config.before(:all) do
    Rspec::Pipeline::FixtureLoader.load if RSpec.configuration.setup_fixtures? && RSpec.configuration.fixtures_repos.any?
  end
end
