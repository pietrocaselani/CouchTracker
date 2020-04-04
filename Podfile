# frozen_string_literal: true

source 'https://github.com/CocoaPods/Specs.git'

SNAPKIT_VERSION = '5.0.1'
OSX_VERSION = '10.12'
IOS_VERSION = '10.0'

def ios_pods
  pod 'Kingfisher', '5.12.0'
  pod 'ActionSheetPicker-3.0', '2.3.0'
  pod 'Tabman', '2.6.3'
  pod 'SnapKit', SNAPKIT_VERSION
  pod 'Bugsnag'
end

def ui_tests_pods
  pod 'KIF', '3.7.8', configurations: ['Debug']
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

  pod 'SwiftLint', '0.39.1'
  ios_pods
end

target 'CouchTrackerUITests' do
  platform :ios, IOS_VERSION
  use_frameworks!
  inhibit_all_warnings!

  ui_tests_pods
end

target 'CouchTrackerDebug' do
  platform :ios, IOS_VERSION
  use_frameworks!
  inhibit_all_warnings!

  pod 'SnapKit', SNAPKIT_VERSION
end
