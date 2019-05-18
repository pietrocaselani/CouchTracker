import ProjectDescription

let baseBundleId = "io.github.pietrocaselani"

func traktSwiftTargets() -> [Target] {
  return [
    Target(name: "TraktSwift-iOS",
           platform: .iOS,
           product: .framework,
           bundleId: "\(baseBundleId).TraktSwift-iOS",
           infoPlist: "TraktSwift-iOS/Info.plist",
           sources: ["TraktSwift/**"],
           dependencies: []),
    Target(name: "TraktSwift",
           platform: .macOS,
           product: .framework,
           bundleId: "\(baseBundleId).TraktSwift",
           infoPlist: "TraktSwift/Info.plist",
           sources: ["TraktSwift/**"],
           dependencies: []),
    Target(name: "TraktSwiftTestable",
           platform: .macOS,
           product: .framework,
           bundleId: "\(baseBundleId).TraktSwiftTestable",
           infoPlist: "TraktSwiftTestable/Info.plist",
           sources: ["TraktSwiftTestable/**"],
           dependencies: []),
    Target(name: "TraktSwiftTests",
           platform: .macOS,
           product: .unitTests,
           bundleId: "\(baseBundleId).TraktSwiftTests",
           infoPlist: "TraktSwiftTests/Info.plist",
           sources: ["TraktSwiftTests/**"],
           dependencies: [])
  ]
}

func tmdbSwiftTargets() -> [Target] {
  return [
    Target(name: "TMDBSwift-iOS",
           platform: .iOS,
           product: .framework,
           bundleId: "\(baseBundleId).TMDBSwift-iOS",
           infoPlist: "TMDBSwift-iOS/Info.plist",
           sources: ["TMDBSwift/**"],
           dependencies: []),
    Target(name: "TMDBSwift",
           platform: .macOS,
           product: .framework,
           bundleId: "\(baseBundleId).TMDBSwift",
           infoPlist: "TMDBSwift/Info.plist",
           sources: ["TMDBSwift/**"],
           dependencies: []),
    Target(name: "TMDBSwiftTestable",
           platform: .macOS,
           product: .framework,
           bundleId: "\(baseBundleId).TMDBSwiftTestable",
           infoPlist: "TMDBSwiftTestable/Info.plist",
           sources: ["TMDBSwiftTestable/**"],
           dependencies: []),
    Target(name: "TMDBSwiftTests",
           platform: .macOS,
           product: .unitTests,
           bundleId: "\(baseBundleId).TMDBSwiftTests",
           infoPlist: "TMDBSwiftTests/Info.plist",
           sources: ["TMDBSwiftTests/**"],
           dependencies: [])
  ]
}

func tvdbSwiftTargets() -> [Target] {
  return [
    Target(name: "TVDBSwift-iOS",
           platform: .iOS,
           product: .framework,
           bundleId: "\(baseBundleId).TVDBSwift-iOS",
           infoPlist: "TVDBSwift-iOS/Info.plist",
           sources: ["TVDBSwift/**"],
           dependencies: []),
    Target(name: "TVDBSwift",
           platform: .macOS,
           product: .framework,
           bundleId: "\(baseBundleId).TVDBSwift",
           infoPlist: "TVDBSwift/Info.plist",
           sources: ["TVDBSwift/**"],
           dependencies: []),
    Target(name: "TVDBSwiftTestable",
           platform: .macOS,
           product: .framework,
           bundleId: "\(baseBundleId).TVDBSwiftTestable",
           infoPlist: "TVDBSwiftTestable/Info.plist",
           sources: ["TVDBSwiftTestable/**"],
           dependencies: []),
    Target(name: "TVDBSwiftTests",
           platform: .macOS,
           product: .unitTests,
           bundleId: "\(baseBundleId).TVDBSwiftTests",
           infoPlist: "TVDBSwiftTests/Info.plist",
           sources: ["TVDBSwiftTests/**"],
           dependencies: [])
  ]
}

func couchTrackerCoreTargets() -> [Target] {
  return [
    Target(name: "CouchTrackerCore-iOS",
           platform: .iOS,
           product: .framework,
           bundleId: "\(baseBundleId).CouchTrackerCore-iOS",
           infoPlist: "CouchTrackerCore-iOS/Info.plist",
           sources: ["CouchTrackerCore/**"],
           dependencies: [
             .target(name: "TMDBSwift-iOS"),
             .target(name: "TVDBSwift-iOS"),
             .target(name: "TraktSwift-iOS"),
           ]),
    Target(name: "CouchTrackerCore",
           platform: .macOS,
           product: .framework,
           bundleId: "\(baseBundleId).CouchTrackerCore",
           infoPlist: "CouchTrackerCore/Info.plist",
           sources: ["CouchTrackerCore/**"],
           dependencies: [
             .target(name: "TMDBSwift-iOS"),
             .target(name: "TVDBSwift-iOS"),
             .target(name: "TraktSwift-iOS"),
           ]),
    Target(name: "CouchTrackerCoreTests",
           platform: .macOS,
           product: .unitTests,
           bundleId: "\(baseBundleId).CouchTrackerCoreTests",
           infoPlist: "CouchTrackerCoreTests/Info.plist",
           sources: ["CouchTrackerCoreTests/**"],
           dependencies: [])
  ]
}

func couchTrackerAppTargets() -> [Target] {
  return [
    Target(name: "CouchTrackerApp",
           platform: .iOS,
           product: .framework,
           bundleId: "\(baseBundleId).CouchTrackerApp",
           infoPlist: "CouchTrackerApp/Info.plist",
           sources: ["CouchTrackerApp/**"],
           dependencies: [
             .target(name: "CouchTrackerPersistence"),
             .target(name: "CouchTrackerDebug"),
             .target(name: "CouchTrackerCore-iOS"),
             .target(name: "TMDBSwift-iOS"),
             .target(name: "TVDBSwift-iOS"),
             .target(name: "TraktSwift-iOS"),
           ]),
    Target(name: "CouchTrackerAppTestable",
           platform: .macOS,
           product: .framework,
           bundleId: "\(baseBundleId).CouchTrackerAppTestable",
           infoPlist: "CouchTrackerAppTestable/Info.plist",
           sources: ["CouchTrackerAppTestable/**"],
           dependencies: [])
  ]
}

func persistanceAndDebugTargets() -> [Target] {
  return [
    Target(name: "CouchTrackerPersistence",
           platform: .iOS,
           product: .framework,
           bundleId: "\(baseBundleId).CouchTrackerPersistence",
           infoPlist: "CouchTrackerPersistence/Info.plist",
           sources: ["CouchTrackerPersistence/**"],
           dependencies: []),
    Target(name: "CouchTrackerDebug",
           platform: .iOS,
           product: .framework,
           bundleId: "\(baseBundleId).CouchTrackerDebug",
           infoPlist: "CouchTrackerDebug/Info.plist",
           sources: ["CouchTrackerDebug/**"],
           dependencies: [
             .target(name: "CouchTrackerCore-iOS"),
           ])
  ]
}

func couchTrackerTargets() -> [Target] {
  return [
    Target(name: "CouchTracker",
           platform: .iOS,
           product: .app,
           bundleId: "\(baseBundleId).couchtracker",
           infoPlist: "CouchTracker/Info.plist",
           sources: ["CouchTracker/**"],
           dependencies: [
             .target(name: "CouchTrackerApp"),
             .target(name: "CouchTrackerPersistence"),
             .target(name: "CouchTrackerDebug"),
             .target(name: "CouchTrackerCore-iOS"),
             .target(name: "TMDBSwift-iOS"),
             .target(name: "TVDBSwift-iOS"),
             .target(name: "TraktSwift-iOS"),
           ]),
    Target(name: "CouchTrackerUITests",
           platform: .macOS,
           product: .unitTests,
           bundleId: "\(baseBundleId).CouchTrackerUITests",
           infoPlist: "CouchTrackerUITests/Info.plist",
           sources: ["CouchTrackerUITests/**"],
           dependencies: [])
  ]
}

func allTargets() -> [Target] {
	let apiTargets = traktSwiftTargets() + tmdbSwiftTargets() + tvdbSwiftTargets()
	let dependencies = couchTrackerCoreTargets() + couchTrackerAppTargets() + persistanceAndDebugTargets()
	let appTargets = couchTrackerTargets()

	return apiTargets + dependencies + appTargets
}

let project = Project(name: "CouchTracker",
                      targets: allTargets())
