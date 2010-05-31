require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'zlib'
require 'mongoid'

Mongoid.configure do |config|
  database = 'bayes_motel_test'
  opts = {} 
  opts[:logger] = Logger.new(File.dirname(__FILE__) + "/mongoid.test.log")
end


$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'bayes_motel'

class Test::Unit::TestCase
end
