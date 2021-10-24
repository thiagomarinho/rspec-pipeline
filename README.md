# Pipelinespec

Create tests for your pipelines to validate dependencies between blocks and other characteristics.

> Only Azure YAML Pipelines are supported at the moment.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pipelinespec'
```

And then execute:

```shell
$ bundle install
```

Or install it yourself as:

```shell
$ gem install pipelinespec
```

## Usage

Add this at the beginning of your spec_helper.rb:

```ruby
require 'pipelinespec'
```

When writing your test you can use the keywords `pipeline`, `stage`, `job` and `step` as example groups, and the example's `subject` will be the corresponding item, filtered by its description. For example:

```ruby
pipeline 'pipeline.yml' do
  stage 'DeployToDev' do
    it { is_expected.to run_after('Build') }
  end
end
```

The test will pass if your pipeline is defined like this:

```yaml
stages:
- stage: Build
  jobs:
  - job: Build
    steps:
      - bash: echo "Build"

- stage: DeployToDev
  dependsOn: Build
  jobs:
  - job: B1
    steps:
    - bash: echo "Deploy to Dev"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/thiagomarinho/pipelinespec.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
