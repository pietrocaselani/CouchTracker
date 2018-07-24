source 'https://github.com/CocoaPods/Specs.git'

RX_SWIFT_VERSION = '4.2.0'

def common_pods
  pod 'SwiftLint', '0.25.1'
  pod 'Trakt', :git => 'https://github.com/pietrocaselani/Trakt-Swift.git', :branch => 'master'
  pod 'TMDB', :git => 'https://github.com/pietrocaselani/TMDB-Swift.git', :branch => 'master'
  pod 'TVDB', :git => 'https://github.com/pietrocaselani/TVDB-Swift.git', :branch => 'master'
  pod 'RxRealm', '0.7.5'
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

target 'CouchTracker' do
  platform :ios, '10.0'
  use_frameworks!
  inhibit_all_warnings!

  ios_pods
end
