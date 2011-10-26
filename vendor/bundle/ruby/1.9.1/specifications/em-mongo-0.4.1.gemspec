# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{em-mongo}
  s.version = "0.4.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{bcg}, %q{PlasticLizard}]
  s.date = %q{2010-12-01}
  s.description = %q{EventMachine driver for MongoDB.}
  s.email = %q{brenden.grace@gmail.com}
  s.homepage = %q{http://github.com/bcg/em-mongo}
  s.rdoc_options = [%q{--charset=UTF-8}]
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{em-mongo}
  s.rubygems_version = %q{1.8.9}
  s.summary = %q{An EventMachine driver for MongoDB.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<eventmachine>, [">= 0.12.10"])
      s.add_runtime_dependency(%q<bson>, [">= 1.1.3"])
      s.add_runtime_dependency(%q<bson_ext>, [">= 1.1.3"])
    else
      s.add_dependency(%q<eventmachine>, [">= 0.12.10"])
      s.add_dependency(%q<bson>, [">= 1.1.3"])
      s.add_dependency(%q<bson_ext>, [">= 1.1.3"])
    end
  else
    s.add_dependency(%q<eventmachine>, [">= 0.12.10"])
    s.add_dependency(%q<bson>, [">= 1.1.3"])
    s.add_dependency(%q<bson_ext>, [">= 1.1.3"])
  end
end
