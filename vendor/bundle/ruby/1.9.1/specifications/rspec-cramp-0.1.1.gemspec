# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rspec-cramp}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Martin Bilski}]
  s.date = %q{2011-09-05}
  s.description = %q{RSpec extension library for Cramp.}
  s.email = %q{gyamtso@gmail.com}
  s.homepage = %q{https://github.com/bilus/rspec-cramp}
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.9}
  s.summary = %q{RSpec helpers for Cramp.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<cramp>, ["~> 0.15"])
      s.add_runtime_dependency(%q<rack>, ["~> 1.3.2"])
      s.add_runtime_dependency(%q<eventmachine>, ["~> 1.0.0.beta.3"])
      s.add_runtime_dependency(%q<http_router>, ["~> 0.10"])
      s.add_runtime_dependency(%q<rspec>, ["~> 2.6"])
    else
      s.add_dependency(%q<cramp>, ["~> 0.15"])
      s.add_dependency(%q<rack>, ["~> 1.3.2"])
      s.add_dependency(%q<eventmachine>, ["~> 1.0.0.beta.3"])
      s.add_dependency(%q<http_router>, ["~> 0.10"])
      s.add_dependency(%q<rspec>, ["~> 2.6"])
    end
  else
    s.add_dependency(%q<cramp>, ["~> 0.15"])
    s.add_dependency(%q<rack>, ["~> 1.3.2"])
    s.add_dependency(%q<eventmachine>, ["~> 1.0.0.beta.3"])
    s.add_dependency(%q<http_router>, ["~> 0.10"])
    s.add_dependency(%q<rspec>, ["~> 2.6"])
  end
end
