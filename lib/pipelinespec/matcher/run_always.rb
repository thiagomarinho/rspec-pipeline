# frozen_string_literal: true

RSpec::Matchers.define :run_always do
  match do |actual|
    actual['condition'].include?('always()')
  end

  failure_message do |_event|
    'Failure!'
  end
end
