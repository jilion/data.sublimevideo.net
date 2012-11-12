guard 'rspec', :version => 2, :cli => "--color" do
  watch('application.rb')       { "spec" }
  watch(%r{^app/(.+)\.rb$})     { "spec" }
  watch(%r{^config/(.+)\.rb$})     { "spec" }

  watch('spec/spec_helper.rb')  { "spec" }
  watch(%r{^spec/.+_spec\.rb$})
end

