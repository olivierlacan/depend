require "bundler/setup"
# WARN: tilt autoloading 'tilt/erb' in a non thread-safe way; explicit require 'tilt/erb' suggested.
require "tilt/erb"
require_relative "depends"

run Sinatra::Application
