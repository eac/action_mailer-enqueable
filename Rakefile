require 'bundler/setup'
require 'rake/testtask'
require 'appraisal'

Rake::TestTask.new(:test) do |test|
  test.pattern = 'test/*_test.rb'
  test.verbose = true
end

task :default => :test
