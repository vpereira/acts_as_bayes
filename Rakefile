#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'minitest/autorun'
require 'rake/testtask'

Rake::TestTask.new do |t|
    t.libs.push "lib"
    t.test_files = FileList['test/*_test.rb']
    t.verbose = true
end
task :default => [:test]
