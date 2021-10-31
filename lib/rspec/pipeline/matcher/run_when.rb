# frozen_string_literal: true

RSpec::Matchers.define :run_when do |event|
  match do |actual|
    actual['condition'].include?(event['condition'])
  end

  failure_message do |_event|
    'Failure!'
  end
end
