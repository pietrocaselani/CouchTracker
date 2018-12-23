source 'https://github.com/CocoaPods/Specs.git'

RX_SWIFT_VERSION = '4.2.0'.freeze

def common_pods
  pod 'SwiftLint', '0.25.1'
  pod 'Trakt', path: './vendor/Trakt-Swift'
  pod 'TMDB', path: './vendor/TMDB-Swift'
  pod 'TVDB', path: './vendor/TVDB-Swift'
  pod 'RxRealm', '0.7.5'
  pod 'RealmSwift', '3.7.6'
  pod 'RxSwift', RX_SWIFT_VERSION
end

def ios_pods
  common_pods
  pod 'R.swift', '4.0.0'
  pod 'Kingfisher', '4.2.0'
  pod 'RxCocoa', RX_SWIFT_VERSION
  pod 'ActionSheetPicker-3.0', '2.2.0'
  pod 'Tabman', '1.4.0'
end

def tests_shared_pods
  pod 'RxTest', RX_SWIFT_VERSION
  pod 'Nimble', '7.1.1'
end

target 'CouchTrackerCore' do
  platform :osx, '10.11'
  use_frameworks!
  inhibit_all_warnings!

  common_pods
end

target 'CouchTrackerCore-iOS' do
  platform :ios, '10.0'
  use_frameworks!
  inhibit_all_warnings!

  common_pods
end

target 'CouchTrackerCoreTests' do
  platform :osx, '10.11'
  use_frameworks!
  inhibit_all_warnings!

  common_pods
  tests_shared_pods
end

target 'CouchTrackerApp' do
  platform :ios, '10.0'
  use_frameworks!
  inhibit_all_warnings!

  ios_pods
end
