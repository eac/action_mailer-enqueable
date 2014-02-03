require 'bundler/setup'
$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), '../lib'))) # lib
require 'debugger'
require 'minitest/autorun'
require 'i18n'
I18n.enforce_available_locales = false
