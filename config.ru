# This file is used by Rack-based servers to start the application.
require 'config/environment'
 
use Rails::Rack::LogTailer
use Rails::Rack::Static
run ActionController::Dispatcher.new
