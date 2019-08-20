# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'europe'
require 'minitest/autorun'
require 'webmock/minitest'
require 'awesome_print'
require 'benchmark'
require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
