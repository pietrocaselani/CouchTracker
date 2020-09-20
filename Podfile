# frozen_string_literal: true

source 'https://github.com/CocoaPods/Specs.git'

IOS_VERSION = '13.0'

def ios_pods
  pod 'Bugsnag'
end

def ui_tests_pods
  pod 'KIF', '3.7.9', configurations: ['Debug']
end

target 'CouchTrackerApp' do
  platform :ios, IOS_VERSION
  use_frameworks!
  inhibit_all_warnings!

  ios_pods
end

target 'CouchTrackerAppTestable' do
  platform :ios, IOS_VERSION
  use_frameworks!
  inhibit_all_warnings!

  ui_tests_pods
end

target 'CouchTracker' do
  platform :ios, IOS_VERSION
  use_frameworks!
  inhibit_all_warnings!

  pod 'SwiftLint', '0.39.2'
  ios_pods
end

target 'CouchTrackerUITests' do
  platform :ios, IOS_VERSION
  use_frameworks!
  inhibit_all_warnings!

  ui_tests_pods
end
