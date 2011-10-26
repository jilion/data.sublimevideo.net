# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rb-fsevent}
  s.version = "0.9.0.pre3"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Thibaud Guillaume-Gentil}, %q{Travis Tilley}]
  s.date = %q{2011-09-30}
  s.description = %q{FSEvents API with Signals catching (without RubyCocoa)}
  s.email = [%q{thibaud@thibaud.me}, %q{ttilley@gmail.com}]
  s.extensions = [%q{ext/rakefile.rb}]
  s.files = [%q{ext/rakefile.rb}]
  s.homepage = %q{http://rubygems.org/gems/rb-fsevent}
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{rb-fsevent}
  s.rubygems_version = %q{1.8.9}
  s.summary = %q{Very simple & usable FSEvents API}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, ["~> 1.0.10"])
      s.add_development_dependency(%q<rspec>, ["~> 2.5.0"])
      s.add_development_dependency(%q<guard-rspec>, ["~> 0.1.9"])
    else
      s.add_dependency(%q<bundler>, ["~> 1.0.10"])
      s.add_dependency(%q<rspec>, ["~> 2.5.0"])
      s.add_dependency(%q<guard-rspec>, ["~> 0.1.9"])
    end
  else
    s.add_dependency(%q<bundler>, ["~> 1.0.10"])
    s.add_dependency(%q<rspec>, ["~> 2.5.0"])
    s.add_dependency(%q<guard-rspec>, ["~> 0.1.9"])
  end
end
