guard 'rspec', cli: '-c', version: 2 do
  watch('spec/spec_helper.rb') { "spec" }
  watch('app.rb')              { "spec" }
  watch(%r{^config/.*})        { "spec" }

  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| "spec/requests/#{m[1]}_spec.rb" }

  # watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  # watch(%r{^lib/(.+)\.rb$})                           { |m| "spec/lib/#{m[1]}_spec.rb" }
  # watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
  # watch('spec/spec_helper.rb')                        { "spec" }
  # watch('config/routes.rb')                           { "spec/routing" }
  # watch('app/controllers/application_controller.rb')  { "spec/controllers" }
  # Capybara request specs
  # watch(%r{^app/views/(.+)/.*\.(erb|haml)$})          { |m| "spec/requests/#{m[1]}_spec.rb" }
end
