ENV['RAILS_ENV'] = 'test'
ENV['RACK_ENV']  = 'test'
require File.expand_path(File.dirname(__FILE__) + '/../config/environment')
require File.expand_path(File.dirname(__FILE__) + '/../../lib/seam/active_record')
require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/pride'
require 'subtle'
require 'timecop'
require 'contrast'
require 'mocha/setup'

Seam::ActiveRecord.setup
