# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{settingslogic}
  s.version = "2.0.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Ben Johnson of Binary Logic}]
  s.date = %q{2010-02-12}
  s.email = %q{bjohnson@binarylogic.com}
  s.extra_rdoc_files = [%q{LICENSE}, %q{README.rdoc}]
  s.files = [%q{LICENSE}, %q{README.rdoc}]
  s.homepage = %q{http://github.com/binarylogic/settingslogic}
  s.rdoc_options = [%q{--charset=UTF-8}]
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.9}
  s.summary = %q{A simple and straightforward settings solution that uses an ERB enabled YAML file and a singleton design pattern.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
