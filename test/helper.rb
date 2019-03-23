require 'shoulda'
require 'simplecov'
require 'minitest/autorun'
require 'zlib'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

SimpleCov.start

require 'bayes_motel'
