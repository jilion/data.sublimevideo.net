# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{async-rack}
  s.version = "0.5.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Konstantin Haase}]
  s.date = %q{2011-02-07}
  s.description = %q{Makes middleware that ships with Rack bullet-proof for async responses.}
  s.email = %q{konstantin.mailinglists@googlemail.com}
  s.homepage = %q{http://github.com/rkh/async-rack}
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.9}
  s.summary = %q{Makes middleware that ships with Rack bullet-proof for async responses.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rack>, ["~> 1.1"])
      s.add_development_dependency(%q<rspec>, [">= 1.3.0"])
    else
      s.add_dependency(%q<rack>, ["~> 1.1"])
      s.add_dependency(%q<rspec>, [">= 1.3.0"])
    end
  else
    s.add_dependency(%q<rack>, ["~> 1.1"])
    s.add_dependency(%q<rspec>, [">= 1.3.0"])
  end
end
