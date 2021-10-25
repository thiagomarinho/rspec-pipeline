# frozen_string_literal: true

RSpec::Matchers.define :run_on_success do
  match do |actual|
    actual['condition'].include?('succeeded()')
  end

  failure_message do |_event|
    'Failure!'
  end
end
