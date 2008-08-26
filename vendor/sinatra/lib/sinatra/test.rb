$:.unshift File.dirname(__FILE__) + "/.."
require "sinatra"
require "test/unit"

Sinatra::Application.default_options.merge!(
  :env => :test,
  :raise_errors => true,
  :logging => false,
  :error_logging => false,
  :run => false
)
