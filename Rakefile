require 'foodcritic'
require 'rubocop/rake_task'
require 'rspec/core/rake_task'

FoodCritic::Rake::LintTask.new do |task|
  task.options = {
    tags: %w(~FC009) # https://github.com/acrmp/foodcritic/issues/233
  }
end
RuboCop::RakeTask.new(:rubocop)
RSpec::Core::RakeTask.new do |task|
  task.rspec_opts = '--color -f d'
end

task default: [:foodcritic, :rubocop, :spec]
