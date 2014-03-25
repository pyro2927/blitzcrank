$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "bundler/gem_tasks"
require "blitzcrank/version"
require 'bundler/version'

task :build do
    system 'gem build blitzcrank.gemspec'
end

task :install do
    system "gem install --local ./blitzcrank-#{Blitzcrank::VERSION}.gem"
end
