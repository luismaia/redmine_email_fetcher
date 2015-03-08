require 'simplecov'
require 'simplecov-rcov'

# Coverage
SimpleCov.start

# Load the Redmine helper
require File.expand_path(File.dirname(__FILE__) + '/../../../test/test_helper')

Rails.backtrace_cleaner.remove_silencers!

ActiveRecord::Fixtures.create_fixtures(File.dirname(__FILE__) + '/fixtures/',
                                       [:email_configurations])
