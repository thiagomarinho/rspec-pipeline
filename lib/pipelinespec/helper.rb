# frozen_string_literal: true

require 'yaml'

def pipeline
  pipeline = YAML.load_file(pipeline_name)

  templated_stages = pipeline['stages'].map do |stage|
    if stage['template']
      load_template('stages', stage['template'], stage['parameters'])
    else
      stage
    end
  end

  pipeline['stages'] = templated_stages.flatten.compact

  pipeline['stages'].each do |stage|
    templated_jobs = stage['jobs'].map do |job|
      if job['template']
        load_template('jobs', job['template'], job['parameters'])
      else
        job
      end
    end

    stage['jobs'] = templated_jobs.flatten.compact

    stage['jobs'].each do |job|
      templated_steps = job['steps'].map do |step|
        if step['template']
          load_template('steps', step['template'], step['parameters'])
        else
          step
        end
      end

      job['steps'] = templated_steps.flatten.compact
    end
  end

  pipeline
end

def load_template(template_type, template, parameters)
  template_content = File.read(template)

  if parameters
    parameters.each do |key, value|
      template_content = template_content.gsub("${{ parameters.#{key} }}", value)
    end
  end

  yaml_template = YAML.load(template_content)

  # TODO handle parameter default values
  # TODO validate parameters
  # - throw SyntaxError: parameter used but not defined

  validate_parameters_not_found(parameters, yaml_template)
  validate_required_parameters_not_defined(parameters, yaml_template)

  yaml_template[template_type]
end

def validate_parameters_not_found(parameters, yaml_template)
  parameters_not_found = (parameters || {}).keys - (yaml_template['parameters'] || []).map { |parameter| parameter['name'] }
  raise "These parameters have been defined when you called the template but they are not in the template: #{parameters_not_found.join(', ')}" unless parameters_not_found.empty?
end

def validate_required_parameters_not_defined(parameters, yaml_template)
  required_parameters_not_defined = (yaml_template['parameters'] || []).map { |parameter| parameter['name'] } - (parameters || {}).keys
  raise "These parameters doesn't have default values but are not being defined when you called the template: #{required_parameters_not_defined.join(', ')}" unless required_parameters_not_defined.empty?
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

  step = job_to_search['steps'].find {|item| item['name'] == name }
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
