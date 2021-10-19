RSpec::Matchers.define :run_always do
  match do |actual|
    actual['condition'].include?('always()')
  end

  failure_message do |event|
    "Failure!"
  end
end
