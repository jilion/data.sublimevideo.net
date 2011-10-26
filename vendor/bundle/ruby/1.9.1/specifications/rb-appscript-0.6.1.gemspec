# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rb-appscript}
  s.version = "0.6.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.date = %q{2011-03-19}
  s.extensions = [%q{extconf.rb}]
  s.files = [%q{extconf.rb}]
  s.homepage = %q{http://appscript.sourceforge.net/}
  s.require_paths = [%q{lib}]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8")
  s.rubygems_version = %q{1.8.9}
  s.summary = %q{Ruby appscript (rb-appscript) is a high-level, user-friendly Apple event bridge that allows you to control scriptable Mac OS X applications using ordinary Ruby scripts.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
