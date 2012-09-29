Gem::Specification.new do |s|
  s.name         = 'albizia'
  s.version      = '0.0.1'
  s.date         = '2012-09-29'
  s.summary      = "Albzia is a basic tree implemention"
  s.description  = "A simple gem implementing different kind of tree structures"
  s.authors      = ["Pierre Jambet"]
  s.email        = 'pierre.jambet@gmail.com'
  s.files        = Dir["{lib,spec}/**/*", "[A-Z]*", "init.rb"] - ["Gemfile.lock"]
  s.require_path = "lib"
  s.homepage     = 'http://pjambet.github.com/albizia/'
end
