# frozen_string_literal: true

source 'https://rubygems.org'

gem 'cocoapods', '1.9.1'
gem 'fastlane', '2.144.0'
gem 'slather', '2.4.7'

# Security Alerts
gem 'nokogiri', '>= 1.10.8'

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)
