# frozen_string_literal: true

RSpec::Matchers.define :run_on_failure do
  match do |actual|
    actual['condition'].include?('failure()')
  end

  failure_message do |_event|
    'Failure!'
  end
end
