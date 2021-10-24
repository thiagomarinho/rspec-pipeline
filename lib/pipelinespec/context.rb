shared_context "pipeline context", :type => :pipeline do
  let!(:pipeline_name) { self.class.top_level_description }
end

shared_context "stage context", :type => :stage do
  subject { stage(RSpec.current_example.metadata[:example_group][:description]) }
end

shared_context "job context", :type => :job do
  subject {
    job(RSpec.current_example.metadata[:example_group][:parent_example_group][:description],
      RSpec.current_example.metadata[:example_group][:description])
  }
end

shared_context "step context", :type => :step do
  subject {
    step(RSpec.current_example.metadata[:example_group][:parent_example_group][:parent_example_group][:description],
      RSpec.current_example.metadata[:example_group][:parent_example_group][:description],
      RSpec.current_example.metadata[:example_group][:description])
  }
end
