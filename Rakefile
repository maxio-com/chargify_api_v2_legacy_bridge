require 'bundler/gem_tasks'

require 'rspec/core/rake_task'

Capybara.allow_gumbo = false

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new
