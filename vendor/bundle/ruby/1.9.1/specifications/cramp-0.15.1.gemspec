# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{cramp}
  s.version = "0.15.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Pratik Naik}]
  s.date = %q{2011-09-28}
  s.description = %q{Cramp is a framework for developing asynchronous web applications.}
  s.email = %q{pratiknaik@gmail.com}
  s.executables = [%q{cramp}]
  s.files = [%q{bin/cramp}]
  s.homepage = %q{http://cramp.in}
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.9}
  s.summary = %q{Asynchronous web framework.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, ["~> 3.0.9"])
      s.add_runtime_dependency(%q<rack>, ["~> 1.3.2"])
      s.add_runtime_dependency(%q<eventmachine>, ["~> 1.0.0.beta.3"])
      s.add_runtime_dependency(%q<thor>, ["~> 0.14.6"])
    else
      s.add_dependency(%q<activesupport>, ["~> 3.0.9"])
      s.add_dependency(%q<rack>, ["~> 1.3.2"])
      s.add_dependency(%q<eventmachine>, ["~> 1.0.0.beta.3"])
      s.add_dependency(%q<thor>, ["~> 0.14.6"])
    end
  else
    s.add_dependency(%q<activesupport>, ["~> 3.0.9"])
    s.add_dependency(%q<rack>, ["~> 1.3.2"])
    s.add_dependency(%q<eventmachine>, ["~> 1.0.0.beta.3"])
    s.add_dependency(%q<thor>, ["~> 0.14.6"])
  end
end
