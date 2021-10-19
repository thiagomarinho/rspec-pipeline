RSpec::Matchers.define :run_on_failure do
  match do |actual|
    actual['condition'].include?('failure()')
  end

  failure_message do |event|
    "Failure!"
  end
end
