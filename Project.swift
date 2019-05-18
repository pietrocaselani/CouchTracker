import ProjectDescription

// MARK: - Extensions

func + (lhs: [String: String], rhs: [String: String]) -> [String: String] {
    return lhs.merging(rhs) { first, second in first }
}

extension Dictionary where Key == String, Value == String {
    func asConfig() -> Configuration {
        return Configuration(settings: self)
    }
}


// MARK: - Constants

let baseBundleId = "io.github.pietrocaselani"
let miniOSVersion = "10.0"

// MARK: - Target structures

enum CouchTracker {
    static let name = "CouchTracker"
    static func target() -> Target {
        return Target(name: CouchTracker.name,
                      platform: .iOS,
                      product: .app,
                      bundleId: "\(baseBundleId).couchtracker",
            infoPlist: "CouchTracker/Info.plist",
            sources: ["CouchTracker/**"],
            resources: ["CouchTracker/Resources/**"],
            dependencies: [
                .target(name: "CouchTrackerApp"),
                .target(name: "CouchTrackerPersistence"),
                .target(name: "CouchTrackerDebug"),
                .target(name: "CouchTrackerCore-iOS"),
                .target(name: "TMDBSwift-iOS"),
                .target(name: "TVDBSwift-iOS"),
                .target(name: "TraktSwift-iOS"),
                ],
            settings: settings())
    }

    private static func settings() -> Settings {
        let debug = [
            "PROVISIONING_PROFILE_SPECIFIER": "match Development io.github.pietrocaselani.couchtracker"
        ] + baseSettingsiOSTargets() + debugCodeSigning()


        let release = [
            "PROVISIONING_PROFILE_SPECIFIER": "match AppStore io.github.pietrocaselani.couchtracker"
        ] + baseSettingsiOSTargets() + releaseCodeSigning()

        return Settings(debug: debug.asConfig(), release: release.asConfig())
    }
}

enum CouchTrackerUITests {
    static let name = "CouchTrackerUITests"

    static func target() -> Target {
        return Target(name: CouchTrackerUITests.name,
                      platform: .macOS,
                      product: .unitTests,
                      bundleId: "\(baseBundleId).CouchTrackerUITests",
            infoPlist: "CouchTrackerUITests/Info.plist",
            sources: ["CouchTrackerUITests/**"],
            dependencies: [
                .target(name: "CouchTrackerAppTestable")
            ],
            settings: settings())
    }

    private static func settings() -> Settings {
        let base = [
            "TEST_HOST": "$(BUILT_PRODUCTS_DIR)/CouchTracker.app/CouchTracker",
            "BUNDLE_LOADER": "$(TEST_HOST)",
            ] + disableCodeSigning() + baseSettingsiOSTargets()
        return Settings(base: base)
    }
}

enum CouchTrackerApp {
    static let name = "CouchTrackerApp"

    static func target() -> Target {
        return Target(name: CouchTrackerApp.name,
                      platform: .iOS,
                      product: .framework,
                      bundleId: "\(baseBundleId).CouchTrackerApp",
            infoPlist: "CouchTrackerApp/Info.plist",
            sources: ["CouchTrackerApp/**"],
            resources: ["CouchTrackerApp/Resources/**"],
            headers: Headers(public: "CouchTrackerApp/Headers/Public/CouchTrackerApp.h"),
            dependencies: [
                .target(name: "CouchTrackerPersistence"),
                .target(name: "CouchTrackerDebug"),
                .target(name: "CouchTrackerCore-iOS"),
                .target(name: "TMDBSwift-iOS"),
                .target(name: "TVDBSwift-iOS"),
                .target(name: "TraktSwift-iOS"),
                ],
        settings: settings())
    }

    private static func settings() -> Settings {
        return Settings(base: baseSettingsiOSTargets(),
                        debug: debugCodeSigning().asConfig(),
                        release: releaseCodeSigning().asConfig())
    }
}

// MARK: - Settings functions

func baseSettingsiOSTargets() -> [String: String] {
    return [
        "IPHONEOS_DEPLOYMENT_TARGET": miniOSVersion,
        "TARGETED_DEVICE_FAMILY": "1",
        "CODE_SIGN_STYLE": "Manual",
        "DEVELOPMENT_TEAM": "B5RPM7SE3L",
    ]
}

func disableCodeSigning() -> [String: String] {
    return ["CODE_SIGN_IDENTITY": ""]
}

func releaseCodeSigning() -> [String: String] {
    return ["CODE_SIGN_IDENTITY": "iPhone Distribution"]
}

func debugCodeSigning() -> [String: String] {
    return ["CODE_SIGN_IDENTITY": "iPhone Developer"]
}

// MARK: - Legacy

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
           dependencies: []),
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
           dependencies: []),
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
           dependencies: []),
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
           dependencies: []),
  ]
}

func couchTrackerAppTargets() -> [Target] {
  return [
    Target(name: "CouchTrackerAppTestable",
           platform: .macOS,
           product: .framework,
           bundleId: "\(baseBundleId).CouchTrackerAppTestable",
           infoPlist: "CouchTrackerAppTestable/Info.plist",
           sources: ["CouchTrackerAppTestable/**"],
           dependencies: []),
  ] + [CouchTrackerApp.target()]
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
           ]),
  ]
}

func allTargets() -> [Target] {
  let apiTargets = traktSwiftTargets() + tmdbSwiftTargets() + tvdbSwiftTargets()
  let dependencies = couchTrackerAppTargets() + couchTrackerCoreTargets() + persistanceAndDebugTargets()
  let appTargets = [CouchTracker.target(), CouchTrackerUITests.target()]

    return appTargets + dependencies + apiTargets
}

// MARK: - Project

let project = Project(name: "CouchTracker",
                      targets: allTargets())
