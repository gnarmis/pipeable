require_relative "./lib/pipeable"

Gem::Specification.new do |s|
  s.name        = "pipeable"
  s.version     = Pipeable::VERSION
  s.date        = "2016-08-08"
  s.summary     = "A small library to help you pipeline discrete invocations"
  s.description = "A small library to help you pipeline discrete invocations"
  s.authors     = ["Gursimran Singh"]
  s.email       = "g@kilotau.com"
  s.files       = ["lib/pipeable.rb"]
  s.homepage    = "https://github.com/gnarmis/pipeable"
  s.license     = "MIT"
end
