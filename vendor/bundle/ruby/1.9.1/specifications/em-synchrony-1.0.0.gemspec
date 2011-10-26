# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{em-synchrony}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Ilya Grigorik}]
  s.date = %q{2011-08-27}
  s.description = %q{Fiber aware EventMachine libraries}
  s.email = [%q{ilya@igvita.com}]
  s.homepage = %q{http://github.com/igrigorik/em-synchrony}
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{em-synchrony}
  s.rubygems_version = %q{1.8.9}
  s.summary = %q{Fiber aware EventMachine libraries}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<eventmachine>, [">= 1.0.0.beta.1"])
    else
      s.add_dependency(%q<eventmachine>, [">= 1.0.0.beta.1"])
    end
  else
    s.add_dependency(%q<eventmachine>, [">= 1.0.0.beta.1"])
  end
end
