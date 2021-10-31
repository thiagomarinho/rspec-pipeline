# frozen_string_literal: true

require 'yaml'

# TODO: handle parameter default values
# TODO: validate parameters
# - throw SyntaxError: parameter used but not defined
module Rspec::Pipeline
  # This class loads and validates templates from YAML files.
  class TemplateLoader
    def initialize
      @repo_stack = ['.']
    end

    def load(type, template, repo, parameters) # rubocop:disable Metrics/MethodLength
      template_content = load_template_file(repo, template)

      parameters&.each do |key, value|
        template_content = template_content.gsub("${{ parameters.#{key} }}", value)
      end

      yaml_template = YAML.safe_load(template_content)

      validate_parameters_not_found(parameters, yaml_template)
      validate_required_parameters_not_defined(parameters, yaml_template)

      yaml_template[type]&.map do |item|
        item['_meta'] = {
          'repo' => repo
        }
      end

      yaml_template[type]
    end

    private

    def load_template_file(repo, template)
      template_file = if repo == '.'
                        template
                      else
                        "spec/fixtures/#{repo}/#{template}"
                      end

      raise "Expected to have a template file called #{template_file}" unless File.exist? template_file

      File.read template_file
    end

    def validate_parameters_not_found(parameters, yaml_template)
      parameters_not_found = (parameters || {}).keys -
                             (yaml_template['parameters'] || []).map { |parameter| parameter['name'] }

      unless parameters_not_found.empty? # rubocop:disable Style/GuardClause
        raise 'These parameters have been defined when you called the template but ' \
          "they are not in the template: #{parameters_not_found.join(', ')}"
      end
    end

    def validate_required_parameters_not_defined(parameters, yaml_template)
      required_parameters_not_defined = (yaml_template['parameters'] || []).map { |parameter| parameter['name'] } -
                                        (parameters || {}).keys

      unless required_parameters_not_defined.empty? # rubocop:disable Style/GuardClause
        raise "These parameters doesn't have default values but are not being defined when you called the " \
          "template: #{required_parameters_not_defined.join(', ')}"
      end
    end
  end
end
