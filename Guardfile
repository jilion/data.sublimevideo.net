guard :rspec do
  watch('config.rb')            { "spec" }
  watch('config.ru')            { "spec" }
  watch('lib/application.rb')   { "spec" }
  watch(%r{^lib/rack/.+\.rb$})  { "spec" }
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }

  watch('spec/spec_helper.rb')  { "spec" }
  watch(%r{^spec/.+_spec\.rb$})
end
