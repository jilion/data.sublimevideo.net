# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{signature}
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Martyn Loughran}]
  s.date = %q{2010-10-29}
  s.description = %q{Simple key/secret based authentication for apis}
  s.email = [%q{me@mloughran.com}]
  s.homepage = %q{http://github.com/mloughran/signature}
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.9}
  s.summary = %q{Simple key/secret based authentication for apis}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ruby-hmac>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.0.0"])
    else
      s.add_dependency(%q<ruby-hmac>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2.0.0"])
    end
  else
    s.add_dependency(%q<ruby-hmac>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2.0.0"])
  end
end
