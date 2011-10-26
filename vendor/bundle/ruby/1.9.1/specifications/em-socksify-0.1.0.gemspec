# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{em-socksify}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Ilya Grigorik}]
  s.date = %q{2011-01-23}
  s.description = %q{EventMachine SOCKSify shim: adds SOCKS support to any protocol}
  s.email = [%q{ilya@igvita.com}]
  s.homepage = %q{http://github.com/igrigorik/em-socksify}
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{em-socksify}
  s.rubygems_version = %q{1.8.9}
  s.summary = %q{EventMachine SOCKSify shim: adds SOCKS support to any protocol}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<eventmachine>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<eventmachine>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<eventmachine>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end
