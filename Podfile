source 'https://github.com/CocoaPods/Specs.git'

RX_SWIFT_VERSION = '4.4.0'.freeze
OSX_VERSION = '10.11'.freeze
IOS_VERSION = '10.0'.freeze

def common_pods
  pod 'NonEmpty', '0.1.2'
  pod 'Trakt', path: './vendor/Trakt-Swift'
  pod 'TMDB', path: './vendor/TMDB-Swift'
  pod 'TVDB', path: './vendor/TVDB-Swift'
  pod 'RxSwift', RX_SWIFT_VERSION
end

def ios_pods
  common_pods
  pod 'R.swift', '5.0.0'
  pod 'Kingfisher', '5.0.1'
  pod 'RxCocoa', RX_SWIFT_VERSION
  pod 'ActionSheetPicker-3.0', '2.2.0'
  pod 'Tabman', '2.1.4'
  pod 'SnapKit', '5.0.0'
  pod 'RxDataSources', '3.1.0'
  pod 'Bugsnag'
end

def persistence_pods
  pod 'RxRealm', '0.7.6'
  pod 'RealmSwift', '3.7.6'
end

def tests_shared_pods
  pod 'RxTest', RX_SWIFT_VERSION
  pod 'Nimble', '7.3.1'
end

target 'CouchTrackerCore' do
  platform :osx, OSX_VERSION
  use_frameworks!
  inhibit_all_warnings!

  common_pods
end

target 'CouchTrackerCore-iOS' do
  platform :ios, IOS_VERSION
  use_frameworks!
  inhibit_all_warnings!

  common_pods
end

target 'CouchTrackerCoreTests' do
  platform :osx, OSX_VERSION
  use_frameworks!
  inhibit_all_warnings!

  common_pods
  tests_shared_pods
end

target 'CouchTrackerApp' do
  platform :ios, IOS_VERSION
  use_frameworks!
  inhibit_all_warnings!

  ios_pods
  persistence_pods
end

target 'CouchTrackerPersistence' do
  platform :ios, IOS_VERSION
  use_frameworks!
  inhibit_all_warnings!

  persistence_pods
end

target 'CouchTracker' do
  platform :ios, IOS_VERSION
  use_frameworks!
  inhibit_all_warnings!

  ios_pods
end
