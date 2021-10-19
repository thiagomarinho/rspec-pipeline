RSpec::Matchers.define :run_on_success_or_failure do
  match do |actual|
    actual['condition'].include?('succeededOrFailed()')
  end

  failure_message do |event|
    "Failure!"
  end
end
