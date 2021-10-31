# frozen_string_literal: true

require_relative 'pipeline_loader'
require_relative 'template_loader'

def pipeline
  pipeline = Rspec::Pipeline::PipelineLoader.new(pipeline_name)

  pipeline.load
end

def stage(name)
  stage = pipeline['stages'].find { |item| item['stage'] == name }

  raise "Stage not found: #{name}" if stage.nil?

  stage['blockType'] = 'Stage'
  stage['blockName'] = stage['stage']

  stage
end

def job(stage_name, name)
  job = stage(stage_name)['jobs'].find { |item| item['job'] == name }

  raise "Job not found: #{name}" if job.nil?

  job['blockType'] = 'Job'
  job['blockName'] = job['job']

  job
end

def step(stage_name, job_name, name)
  job_to_search = job(stage_name, job_name)
  raise "Job #{job_name} doesn't have steps" unless job_to_search['steps']

  step = job_to_search['steps'].find { |item| item['name'] == name }
  raise "Step not found: #{name} (available: #{job_to_search['steps'].map { |item| item['name'] }})" if step.nil?

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
