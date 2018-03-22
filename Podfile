source 'https://github.com/CocoaPods/Specs.git'

def common_pods
  pod 'SwiftLint', '0.23.1'
  pod 'Trakt', :git => 'https://github.com/pietrocaselani/Trakt-Swift.git'
  pod 'TMDB', :git => 'https://github.com/pietrocaselani/TMDB-Swift.git'
  pod 'TVDB', :git => 'https://github.com/pietrocaselani/TVDB-Swift.git'
  pod 'RxRealm', '0.7.5'
  pod 'RxSwift', :git => 'https://github.com/ReactiveX/RxSwift.git', :branch => 'develop'
end

def ios_pods
  common_pods
  pod 'R.swift', '4.0.0'
  pod 'Kingfisher', '4.2.0'
  pod 'RxCocoa', '4.0.0'
  pod 'ActionSheetPicker-3.0', '2.2.0'
  pod 'Tabman', '1.4.0'
end

def tests_shared_pods
  pod 'RxTest', '4.0.0'
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
