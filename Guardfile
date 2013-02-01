guard 'rspec', all_after_pass: false, keep_failed: false do
  watch('application.rb')       { "spec" }
  watch(%r{^config/.+\.rb$})    { "spec" }
  watch(%r{^lib/rack/.+\.rb$})  { "spec" }
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }

  watch('spec/spec_helper.rb')  { "spec" }
  watch(%r{^spec/.+_spec\.rb$})
end
