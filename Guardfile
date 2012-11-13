guard 'rspec', :version => 2, :cli => "--color" do
  watch('application.rb')       { "spec" }
  watch(%r{^config/.+\.rb$})    { "spec" }
  watch(%r{^lib/rack/.+\.rb$})  { "spec" }
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }

  watch('spec/spec_helper.rb')  { "spec" }
  watch(%r{^spec/.+_spec\.rb$})
end

