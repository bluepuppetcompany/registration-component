ENV['CONSOLE_DEVICE'] ||= 'stdout'
ENV['LOG_LEVEL'] ||= '_min'

puts RUBY_DESCRIPTION

require_relative '../init.rb'

require 'test_bench'; TestBench.activate

require 'pp'

require 'registration_component/controls'
require 'user_email_address/client/controls'

module RegistrationComponent; end
include RegistrationComponent
