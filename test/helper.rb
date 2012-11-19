require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'zlib'
require 'mongoid'
require 'mongo'


Mongoid.load!("mongoid.yml", :test)

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'bayes_motel'

class Test::Unit::TestCase
end
