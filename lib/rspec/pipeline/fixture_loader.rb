# frozen_string_literal: true

require 'fileutils'

module RSpec::Pipeline # rubocop:disable Style/ClassAndModuleChildren
  # This class configures and loads fixtures. It this moment, the only fixtures we have are repositories usually
  # utilized for remote templates.
  class FixtureLoader
    def self.load(verbose: true)
      ['spec', File.join('spec', 'fixtures')].each { |dir| safe_mkdir(dir, verbose: verbose) }

      RSpec.configuration.fixtures_repos.each do |repo_definition|
        if repo_definition[:path]
          safe_cp_r(repo_definition[:path], File.join('spec', 'fixtures', repo_definition[:name]), verbose: verbose)
        elsif repo_definition[:repo]
          safe_git_clone(repo_definition, verbose: verbose)
        else
          warn "!! invalid fixture repository definition: #{repo_definition}"
        end
      end
    end

    def self.safe_mkdir(dir, verbose: true)
      if File.exist? dir
        warn "!! #{dir} already exists and is not a directory" unless File.directory? dir
      else
        begin
          FileUtils.mkdir dir
        rescue Errno::EEXIST => e
          raise e unless File.directory? dir
        end

        puts " + #{dir}/" if verbose
      end
    end

    def self.safe_cp_r(src, dest, verbose: true) # rubocop:disable Metrics/MethodLength
      if File.exist? dest
        warn "!! #{dest} already exists and is not a directory" unless File.directory? dest
      elsif !File.exist? src
        warn "!! #{src} not found"
      else
        begin
          FileUtils.cp_r src, dest
        rescue Errno::EEXIST => e
          raise e unless File.directory? dest
        end

        puts " + #{dest}/" if verbose
      end
    end

    def self.safe_git_clone(repo_definition, verbose: true) # rubocop:disable Metrics/MethodLength
      dest = File.join('spec', 'fixtures', repo_definition[:name])

      if File.exist? dest
        if File.directory? dest
          if File.exist? "#{dest}/.git"
            git_pull_and_checkout(repo_definition, dest)
          else
            warn "!! #{dest} already exists and is not a git repo"
          end
        else
          warn "!! #{dest} already exists and is not a directory"
        end
      else
        `git clone #{repo_definition[:repo]} #{dest}`

        puts " + #{dest}/" if verbose
      end
    end

    def self.git_pull_and_checkout(repo_definition, dest)
      `git -C #{dest} pull`

      ref_to_checkout = (repo_definition[:ref] || 'main')
      `git -C #{dest} checkout #{ref_to_checkout}`
    end
  end
end
