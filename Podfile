def common_pods
  pod 'Moya/RxSwift', '8.0.5'
  pod 'SwiftLint', '0.21.0'
  pod 'Moya-ObjectMapper/RxSwift', '2.3.2'
end

def ios_pods
  common_pods
  pod 'R.swift', '3.3.0'
  pod 'Carlos', '0.9.1'
end

def tests_shared_pods
  pod 'RxTest', '3.6.1'
end

target 'CouchTrackerUgly' do
  platform :ios, '9.0'
  use_frameworks!
  inhibit_all_warnings!

  ios_pods
end

target 'CouchTrackerFastTests' do
  platform :osx, '10.11'
  use_frameworks!
  inhibit_all_warnings!
  
  common_pods
  tests_shared_pods
end

target 'CouchTracker' do
  platform :ios, '9.0'
  use_frameworks!
  inhibit_all_warnings!

  ios_pods

  target 'CouchTrackerTests' do
    inherit! :search_paths
    tests_shared_pods
  end
end

target 'Trakt' do
  platform :ios, '9.0'
  use_frameworks!
  inhibit_all_warnings!

  common_pods
end

target 'Trakt-Mac' do
  platform :osx, '10.11'
  use_frameworks!
  inhibit_all_warnings!

  common_pods

  target 'Trakt-MacTests' do
    inherit! :search_paths
    tests_shared_pods
  end
end

target 'TMDB' do
  platform :ios, '9.0'
  use_frameworks!
  inhibit_all_warnings!

  common_pods
end

target 'TMDB-Mac' do
  platform :osx, '10.11'
  use_frameworks!
  inhibit_all_warnings!

  common_pods

  target 'TMDB-MacTests' do
    inherit! :search_paths
    tests_shared_pods
  end
end
