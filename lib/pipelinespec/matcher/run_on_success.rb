# frozen_string_literal: true

RSpec::Matchers.define :run_on_success do
  match do |actual|
    !actual['condition'] || actual['condition'].include?('succeeded()')
  end

  failure_message do |_event|
    "Expected condition to include succeeded() but the actual value is #{actual['condition']} instead"
  end
end
