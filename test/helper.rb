require 'bundler/setup'
$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), '../lib'))) # lib
require 'debugger'
require 'minitest/autorun'
