require 'yaml'

def pipeline
  YAML.load_file(pipeline_name)
end

def stage(name)
  stage = pipeline['stages'].find { |stage| stage['stage'] == name }

  raise "Stage not found: #{name}" if stage.nil?

  stage['blockType'] = 'Stage'
  stage['blockName'] = stage['stage']

  stage
end

def job(stage_name, name)
  job = stage(stage_name)['jobs'].find { |job| job['job'] == name }

  raise "Job not found: #{name}" if job.nil?

  job['blockType'] = 'Job'
  job['blockName'] = job['job']

  job
end

def step(stage_name, job_name, name)
  step = job(stage_name, job_name)['steps'].find { |step| step['name'] == name }

  raise "Step not found: #{name}" if step.nil?

  step['blockType'] = 'Step'
  step['blockName'] = step['name']

  step
end

# events
def push_to_branch(name)
  {
    'type' => :push,
    'branch' => name,
    'condition' => "eq(variables['build.sourceBranch'], 'refs/heads/#{name}'"
  }
end

def push_to_master
  push_to_branch 'master'
end

def pull_request
  # TODO
end

# context 'stage[Build]' do # TODO we could use this to reference to a stage, build or step