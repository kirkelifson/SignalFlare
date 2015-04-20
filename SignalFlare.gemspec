Gem::Specification.new do |s|
  s.name        = 'SignalFlare'
  s.version     = '1.1.0'
  s.date        = '2015-04-15'
  s.summary     = 'Signal Flare'
  s.description = 'Updates DNS records on CloudFlare for systems on dynamically allocated IP addresses'
  s.authors     = ['Kirk Elifson']
  s.email       = 'kirk@parodybit.net'
  s.files       = ['lib/SignalFlare.rb']
  s.homepage    = 'https://rubygems.org/gems/SignalFlare'
  s.license     = 'MIT'

  # Dependencies
  s.add_dependency 'cloudflare', '~> 2.0'
end
