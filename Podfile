def shared_pods
  pod 'Carlos', '0.9.1'
  pod 'Moya/RxSwift', '8.0.5'
  pod 'R.swift', '3.3.0'
  pod 'SwiftLint', '0.21.0'
  pod 'Moya-ObjectMapper/RxSwift', '2.3.2'
end

target 'CouchTrackerUgly' do
  use_frameworks!
  inhibit_all_warnings!

  shared_pods
end

target 'CouchTracker' do
  use_frameworks!
  inhibit_all_warnings!

  shared_pods
  

  target 'CouchTrackerTests' do
    inherit! :search_paths
    pod 'RxTest', '3.6.1'
  end

end
