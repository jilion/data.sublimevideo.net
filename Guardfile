guard 'rspec', :version => 2, :cli => "--color" do
  watch('application.rb')       { "spec" }
  watch('config/routes.rb')     { "spec" }
  watch('spec/spec_helper.rb')  { "spec" }

  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^app/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
end
