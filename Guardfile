guard :rspec, cmd: 'bundle exec rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/blitzcrank/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
end

