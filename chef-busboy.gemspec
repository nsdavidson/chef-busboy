Gem::Specification.new do |s|
  s.name        = 'chef-busboy'
  s.version     = '0.0.2'
  s.date        = '2014-03-21'
  s.summary     = 'Command line tool for chef-server'
  s.description = 'Command line tool for chef-server, implementing a small subset of activities'
  s.authors     = 'Nolan Davidson'
  s.email       = 'ndavidson@scrippsnetworks.com'
  s.add_runtime_dependency 'ridley'
  s.add_runtime_dependency 'thor'
  s.files       = ["lib/chef-busboy.rb"]
  s.executables << 'busboy'

end
