# frozen_string_literal: true

require 'yaml'

module Pipelinespec
  # This class loads the pipeline from a YAML file, also calling required methods to
  # evaluate templates.
  class PipelineLoader
    def initialize(pipeline_name)
      @pipeline_name = pipeline_name
      @template_loader = TemplateLoader.new
    end

    def load
      pipeline = YAML.load_file(@pipeline_name)

      pipeline['stages'] = evaluate_stages(pipeline)

      pipeline['stages'].each do |stage|
        stage['jobs'] = evaluate_jobs(stage, pipeline)

        stage['jobs'].each do |job|
          job['steps'] = evaluate_steps(job, stage, pipeline)
        end
      end

      pipeline
    end

    private

    def evaluate_stages(pipeline)
      templated_items = pipeline['stages'].map do |item|
        if item['template']
          load_template(item, 'stages', [pipeline])
        else
          item
        end
      end

      templated_items.flatten.compact
    end

    def evaluate_jobs(stage, pipeline)
      templated_items = stage['jobs'].map do |item|
        if item['template']
          load_template(item, 'jobs', [stage, pipeline])
        else
          item
        end
      end

      templated_items.flatten.compact
    end

    def evaluate_steps(job, stage, pipeline)
      templated_steps = job['steps'].map do |step|
        if step['template']
          load_template(step, 'steps', [job, stage, pipeline])
        else
          step
        end
      end

      templated_steps.flatten.compact
    end

    def load_template(template, type, context)
      template_name, template_repo = parse_template_metadata(template, context)

      @template_loader.load(type, template_name, template_repo, template['parameters'])
    end

    def parse_template_metadata(template, context)
      if template['template'].include? '@'
        template['template'].split '@'
      else
        item_with_metadata = context.detect { |item| item['_meta'] && item['_meta']['repo'] }

        if item_with_metadata
          [template['template'], item_with_metadata['_meta']['repo']]
        else
          [template['template'], '.']
        end
      end
    end
  end
end
