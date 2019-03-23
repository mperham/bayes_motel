lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'bayes_motel'

Gem::Specification.new do |gem|
  gem.name          = "bayes_motel"
  gem.summary       = %Q{Bayesian classification engine}
  gem.description   = %Q{http://www.mikeperham.com/2010/04/28/bayes_motel-bayesian-classification-for-ruby/}
  gem.email         = "mperham@gmail.com"
  gem.homepage      = "http://github.com/mperham/bayes_motel"
  gem.authors       = ["Mike Perham"]
  gem.version       = BayesMotel::VERSION
  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rake", "~> 12.3"
  gem.add_development_dependency "shoulda", "~> 3.5"
  gem.add_development_dependency "shoulda-matchers", "~> 2.0"
  gem.add_development_dependency "simplecov", ">= 0.16"
  gem.add_development_dependency "minitest", "> 5.11"
end
