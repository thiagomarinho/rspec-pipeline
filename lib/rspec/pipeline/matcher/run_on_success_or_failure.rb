# frozen_string_literal: true

RSpec::Matchers.define :run_on_success_or_failure do
  match do |actual|
    actual['condition'].include?('succeededOrFailed()')
  end

  failure_message do |_event|
    'Failure!'
  end
end
