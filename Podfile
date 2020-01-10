source 'https://github.com/CocoaPods/Specs.git'

RX_SWIFT_VERSION = '5.0.1'.freeze
SNAPKIT_VERSION = '5.0.1'.freeze
MOYA_VERSION = '14.0.0-beta.6'.freeze
OSX_VERSION = '10.12'.freeze
IOS_VERSION = '10.0'.freeze

def api_pods
  pod 'Moya/RxSwift', git: 'https://github.com/Moya/Moya.git', tag: MOYA_VERSION
end

def sync_pods
  api_pods
  pod 'RxSwift', git: 'https://github.com/ReactiveX/RxSwift.git', tag: RX_SWIFT_VERSION
end

def ios_pods
  sync_pods
  pod 'Kingfisher', '5.12.0'
  pod 'RxCocoa', git: 'https://github.com/ReactiveX/RxSwift.git', tag: RX_SWIFT_VERSION
  pod 'ActionSheetPicker-3.0', '2.3.0'
  pod 'Tabman', '2.6.3'
  pod 'SnapKit', SNAPKIT_VERSION
  pod 'RxDataSources', '4.0.1'
  pod 'Bugsnag'
end

def persistence_pods
  pod 'RxRealm', '2.0.0'
  pod 'RealmSwift', '4.1.1'
end

def tests_shared_pods
  pod 'RxTest', git: 'https://github.com/ReactiveX/RxSwift.git', tag: RX_SWIFT_VERSION
  pod 'RxNimble/RxTest'
  pod 'SnapshotTesting', '1.7.0'
end

def ui_tests_pods
  pod 'KIF', '3.7.8', configurations: ['Debug']
end

target 'CouchTrackerCore' do
  platform :ios, IOS_VERSION
  use_frameworks!
  inhibit_all_warnings!

  sync_pods
end

target 'CouchTrackerCoreTests' do
  platform :ios, IOS_VERSION
  use_frameworks!
  inhibit_all_warnings!

  sync_pods
  tests_shared_pods
end

target 'CouchTrackerSync' do
  platform :ios, IOS_VERSION
  use_frameworks!
  inhibit_all_warnings!

  sync_pods
end

target 'CouchTrackerSyncTests' do
  platform :ios, IOS_VERSION
  use_frameworks!
  inhibit_all_warnings!

  tests_shared_pods
end

target 'CouchTrackerApp' do
  platform :ios, IOS_VERSION
  use_frameworks!
  inhibit_all_warnings!

  ios_pods
  persistence_pods
end

target 'CouchTrackerAppTestable' do
  platform :ios, IOS_VERSION
  use_frameworks!
  inhibit_all_warnings!

  ui_tests_pods
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

target 'TraktSwift' do
  platform :ios, IOS_VERSION
  use_frameworks!
  inhibit_all_warnings!

  api_pods
end

target 'TraktSwiftTests' do
  platform :ios, IOS_VERSION
  use_frameworks!
  inhibit_all_warnings!

  tests_shared_pods
end

target 'TraktSwiftTestable' do
  platform :ios, IOS_VERSION
  use_frameworks!
  inhibit_all_warnings!

  api_pods
end

target 'TMDBSwift' do
  platform :ios, IOS_VERSION
  use_frameworks!
  inhibit_all_warnings!

  api_pods
end

target 'TMDBSwiftTests' do
  platform :ios, IOS_VERSION
  use_frameworks!
  inhibit_all_warnings!

  tests_shared_pods
end

target 'TVDBSwift' do
  platform :ios, IOS_VERSION
  use_frameworks!
  inhibit_all_warnings!

  api_pods
end

target 'TVDBSwiftTests' do
  platform :ios, IOS_VERSION
  use_frameworks!
  inhibit_all_warnings!

  tests_shared_pods
end
