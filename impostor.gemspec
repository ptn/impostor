lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'impostor/version'

Gem::Specification.new do |s|
  s.name            = 'impostor'
  s.version         = Impostor::VERSION
  s.summary         = "An email-based implementation of the Turing test"
  s.description     = "Ask questions via email to two other players and try to guess which is which"
  s.authors         = ["Pablo Torres"]
  s.email           = 'tn.pablo@gmail.com'
  s.homepage        = 'http://github.com/ptn/impostor'

  s.files           = Dir.glob("{bin,lib}/**/*") + %w(README)
  s.executables     = ['impostor'] 
  s.require_path    = 'lib'

  s.add_dependency  "mail"
end
