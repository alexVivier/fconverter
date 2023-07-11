Gem::Specification.new do |s|
  s.name        = "fconverter"
  s.version     = "0.1.1"
  s.summary     = "File converter"
  s.description = "A file converter with many options."
  s.authors     = ["Alexis VIVIER"]
  s.email       = "alexis@nevertoolate.studio"
  s.files       = ["bin/fconverter", "lib/fconverter.rb"]
  s.executables = ["fconverter"]
  s.homepage    =
    "https://rubygems.org/gems/fconverter"
  s.license       = "MIT"
  s.add_dependency 'thor'
  s.add_dependency 'csv'
  s.add_dependency 'json'
  s.add_dependency 'tty-prompt'
end
