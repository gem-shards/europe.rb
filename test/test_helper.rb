require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'europe'
require 'minitest/autorun'
require 'webmock/minitest'
require 'awesome_print'
require 'benchmark'
