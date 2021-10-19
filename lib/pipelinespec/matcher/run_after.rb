RSpec::Matchers.define :run_after do |thing|
  match do |actual|
    if actual['dependsOn'].is_a?(Array)
      actual['dependsOn'].include?(thing)
    else
      actual['dependsOn'] == thing
    end

  end

  failure_message do |event|
    "#{actual['blockType']} \"#{actual['blockName']}\" was expected to depend on #{actual['blockType']} \"#{thing}\" but depends on \"#{actual['dependsOn']}\" instead."
  end
end
