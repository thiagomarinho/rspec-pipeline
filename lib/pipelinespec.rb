# frozen_string_literal: true

require_relative 'pipelinespec/version'
require 'pipelinespec/matcher'
require 'pipelinespec/helper'
require 'pipelinespec/context'

module Pipelinespec
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
end
