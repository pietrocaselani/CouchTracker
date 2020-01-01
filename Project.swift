import ProjectDescription

// MARK: - Extensions

func + (lhs: [String: String], rhs: [String: String]) -> [String: String] {
  return lhs.merging(rhs) { first, _ in first }
}

extension Dictionary where Key == String, Value == String {
  func asConfig() -> Configuration {
    return Configuration(settings: self)
  }
}

// MARK: - Constants

let baseBundleId = "io.github.pietrocaselani"
let miniOSVersion = "10.0"
let minmacOSVersion = "10.12"

// MARK: - iOS Target structures

enum CouchTracker {
  static let name = "CouchTracker"
  static func target() -> Target {
    return Target(
      name: CouchTracker.name,
      platform: .iOS,
      product: .app,
      bundleId: "\(baseBundleId).couchtracker",
      infoPlist: "CouchTracker/Info.plist",
      sources: ["CouchTracker/**"],
      resources: ["CouchTracker/Resources/**/*.{xcassets,png,strings,json,storyboard}"],
      actions: buildPhases(),
      dependencies: [
        .target(name: CouchTrackerApp.name),
        .target(name: CouchTrackerPersistence.name),
        .target(name: CouchTrackerDebug.name),
        .target(name: CouchTrackerCore.name),
        .target(name: TMDBSwift.name),
        .target(name: TVDBSwift.name),
        .target(name: TraktSwift.name)
      ],
      settings: settings()
    )
  }

  private static func settings() -> Settings {
    let debug = ([
      "PROVISIONING_PROFILE_SPECIFIER": "match Development io.github.pietrocaselani.couchtracker"
    ] + iOSBaseSettings() + debugCodeSigning() + sharedBaseDebugSettings()).asConfig()

    let release = ([
      "PROVISIONING_PROFILE_SPECIFIER": "match AppStore io.github.pietrocaselani.couchtracker"
    ] + iOSBaseSettings() + releaseCodeSigning() + sharedBaseReleaseSettings()).asConfig()

    return Settings(debug: debug, release: release)
  }

  private static func buildPhases() -> [TargetAction] {
    return [
      TargetAction.post(path: "build_phases/swiftlint", arguments: [], name: "SwiftLint")
    ]
  }
}

enum CouchTrackerApp {
  static let name = "CouchTrackerApp"

  static func target() -> Target {
    return Target(
      name: CouchTrackerApp.name,
      platform: .iOS,
      product: .framework,
      bundleId: "\(baseBundleId).CouchTrackerApp",
      infoPlist: "CouchTrackerApp/Info.plist",
      sources: ["CouchTrackerApp/**"],
      resources: ["CouchTrackerApp/Resources/**/*.{xcassets,png,strings,json}"],
      headers: Headers(public: "CouchTrackerApp/Headers/Public/CouchTrackerApp.h"),
      dependencies: [
        .target(name: CouchTrackerPersistence.name),
        .target(name: CouchTrackerDebug.name),
        .target(name: CouchTrackerCore.name),
        .target(name: TMDBSwift.name),
        .target(name: TVDBSwift.name),
        .target(name: TraktSwift.name)
      ],
      settings: settings()
    )
  }

  private static func settings() -> Settings {
    let debug = (debugCodeSigning() + sharedBaseDebugSettings()).asConfig()
    let release = (releaseCodeSigning() + sharedBaseReleaseSettings()).asConfig()

    return Settings(
      base: iOSBaseSettings(),
      debug: debug,
      release: release
    )
  }
}

enum CouchTrackerAppTestable {
  static let name = "CouchTrackerAppTestable"

  static func target() -> Target {
    return Target(
      name: CouchTrackerAppTestable.name,
      platform: .iOS,
      product: .framework,
      bundleId: "\(baseBundleId).CouchTrackerAppTestable",
      infoPlist: "CouchTrackerAppTestable/Info.plist",
      sources: ["CouchTrackerAppTestable/**"],
      headers: Headers(public: "CouchTrackerAppTestable/Headers/Public/CouchTrackerAppTestable.h"),
      dependencies: [
        .target(name: CouchTrackerCore.name),
        .target(name: CouchTrackerApp.name)
      ],
      settings: settings()
    )
  }

  private static func settings() -> Settings {
    let debug = (debugCodeSigning() + sharedBaseDebugSettings()).asConfig()
    let release = (releaseCodeSigning() + sharedBaseReleaseSettings()).asConfig()

    return Settings(
      base: iOSBaseSettings(),
      debug: debug,
      release: release
    )
  }
}

enum CouchTrackerPersistence {
  static let name = "CouchTrackerPersistence"

  static func target() -> Target {
    return Target(
      name: CouchTrackerPersistence.name,
      platform: .iOS,
      product: .framework,
      bundleId: "\(baseBundleId).CouchTrackerPersistence",
      infoPlist: "CouchTrackerPersistence/Info.plist",
      sources: ["CouchTrackerPersistence/**"],
      headers: Headers(public: "CouchTrackerPersistence/Headers/Public/CouchTrackerPersistence.h"),
      settings: settings()
    )
  }

  private static func settings() -> Settings {
    let debug = (debugCodeSigning() + sharedBaseDebugSettings()).asConfig()
    let release = (releaseCodeSigning() + sharedBaseReleaseSettings()).asConfig()

    return Settings(
      base: iOSBaseSettings(),
      debug: debug,
      release: release
    )
  }
}

enum CouchTrackerDebug {
  static let name = "CouchTrackerDebug"

  static func target() -> Target {
    return Target(
      name: CouchTrackerDebug.name,
      platform: .iOS,
      product: .framework,
      bundleId: "\(baseBundleId).CouchTrackerDebug",
      infoPlist: "CouchTrackerDebug/Info.plist",
      sources: ["CouchTrackerDebug/**"],
      headers: Headers(public: "CouchTrackerDebug/Headers/Public/CouchTrackerDebug.h"),
      dependencies: [
        .target(name: CouchTrackerCore.name)
      ],
      settings: settings()
    )
  }

  private static func settings() -> Settings {
    let debug = (debugCodeSigning() + sharedBaseDebugSettings()).asConfig()
    let release = (releaseCodeSigning() + sharedBaseReleaseSettings()).asConfig()

    return Settings(
      base: iOSBaseSettings(),
      debug: debug,
      release: release
    )
  }
}

enum CouchTrackerCore {
  static let name = "CouchTrackerCore"

  static func target() -> Target {
    return Target(
      name: CouchTrackerCore.name,
      platform: .iOS,
      product: .framework,
      bundleId: "\(baseBundleId).CouchTrackerCore",
      infoPlist: "CouchTrackerCore/Info.plist",
      sources: ["CouchTrackerCore/**"],
      resources: ["CouchTrackerCore/Resources/**/*.{xcassets,png,strings,json}"],
      headers: Headers(public: "CouchTrackerCore/Headers/Public/CouchTrackerCore.h"),
      dependencies: [
        .target(name: TMDBSwift.name),
        .target(name: TVDBSwift.name),
        .target(name: TraktSwift.name)
      ],
      settings: settings()
    )
  }

  private static func settings() -> Settings {
    let debug = (debugCodeSigning() + sharedBaseDebugSettings()).asConfig()
    let release = (releaseCodeSigning() + sharedBaseReleaseSettings()).asConfig()

    return Settings(
      base: iOSBaseSettings(),
      debug: debug,
      release: release
    )
  }
}

enum CouchTrackerCoreTests {
  static let name = "CouchTrackerCoreTests"

  static func target() -> Target {
    return Target(
      name: CouchTrackerCoreTests.name,
      platform: .iOS,
      product: .unitTests,
      bundleId: "\(baseBundleId).CouchTrackerCoreTests",
      infoPlist: "CouchTrackerCoreTests/Info.plist",
      sources: ["CouchTrackerCoreTests/**"],
      dependencies: [
        .target(name: CouchTrackerCore.name),
        .target(name: TraktSwiftTestable.name),
        .target(name: TMDBSwiftTestable.name),
        .target(name: TVDBSwiftTestable.name)
      ],
      settings: settings()
    )
  }

  private static func settings() -> Settings {
    return Settings(base: iOSBaseSettings())
  }
}

enum CouchTrackerSync {
  static let name = "CouchTrackerSync"

  static func target() -> Target {
    return Target(
      name: CouchTrackerSync.name,
      platform: .iOS,
      product: .framework,
      bundleId: "\(baseBundleId).CouchTrackerSync",
      infoPlist: "CouchTrackerSync/Info.plist",
      sources: ["CouchTrackerSync/**"],
      headers: Headers(public: "CouchTrackerSync/Headers/Public/CouchTrackerSync.h"),
      dependencies: [
        .target(name: TraktSwift.name)
      ],
      settings: settings()
    )
  }

  private static func settings() -> Settings {
    let debug = (debugCodeSigning() + sharedBaseDebugSettings()).asConfig()
    let release = (releaseCodeSigning() + sharedBaseReleaseSettings()).asConfig()

    return Settings(
      base: iOSBaseSettings(),
      debug: debug,
      release: release
    )
  }
}

enum CouchTrackerSyncTests {
  static let name = "CouchTrackerSyncTests"

  static func target() -> Target {
    return Target(
      name: CouchTrackerSyncTests.name,
      platform: .iOS,
      product: .unitTests,
      bundleId: "\(baseBundleId).CouchTrackerSyncTests",
      infoPlist: "CouchTrackerSyncTests/Info.plist",
      sources: ["CouchTrackerSyncTests/**"],
      resources: ["CouchTrackerSyncTests/**/*.json"],
      dependencies: [
        .target(name: CouchTrackerSync.name),
        .target(name: TraktSwiftTestable.name)
      ],
      settings: settings()
    )
  }

  private static func settings() -> Settings {
    return Settings(base: iOSBaseSettings())
  }
}

enum TraktSwift {
  static let name = "TraktSwift"

  static func target() -> Target {
    return Target(
      name: TraktSwift.name,
      platform: .iOS,
      product: .framework,
      bundleId: "\(baseBundleId).TraktSwift",
      infoPlist: "TraktSwift/Info.plist",
      sources: ["TraktSwift/**"],
      headers: Headers(public: "TraktSwift/Headers/Public/TraktSwift.h"),
      settings: settings()
    )
  }

  private static func settings() -> Settings {
    let debug = (debugCodeSigning() + sharedBaseDebugSettings()).asConfig()
    let release = (releaseCodeSigning() + sharedBaseReleaseSettings()).asConfig()

    return Settings(
      base: iOSBaseSettings(),
      debug: debug,
      release: release
    )
  }
}

enum TraktSwiftTests {
  static let name = "TraktSwiftTests"

  static func target() -> Target {
    return Target(
      name: TraktSwiftTests.name,
      platform: .iOS,
      product: .unitTests,
      bundleId: "\(baseBundleId).TraktSwiftTests",
      infoPlist: "TraktSwiftTests/Info.plist",
      sources: ["TraktSwiftTests/**"],
      dependencies: [
        .target(name: TraktSwiftTestable.name),
        .target(name: TraktSwift.name)
      ],
      settings: settings()
    )
  }

  private static func settings() -> Settings {
    return Settings(base: iOSBaseSettings())
  }
}

enum TraktSwiftTestable {
  static let name = "TraktSwiftTestable"

  static func target() -> Target {
    return Target(
      name: TraktSwiftTestable.name,
      platform: .iOS,
      product: .framework,
      bundleId: "\(baseBundleId).TraktSwiftTestable",
      infoPlist: "TraktSwiftTestable/Info.plist",
      sources: ["TraktSwiftTestable/**"],
      resources: ["TraktSwiftTestable/Resources/**/*.{xcassets,png,strings,json}"],
      headers: Headers(public: "TraktSwiftTestable/Headers/Public/TraktSwiftTestable.h"),
      dependencies: [
        .target(name: TraktSwift.name)
      ],
      settings: settings()
    )
  }

  private static func settings() -> Settings {
    let debug = (debugCodeSigning() + sharedBaseDebugSettings()).asConfig()
    let release = (releaseCodeSigning() + sharedBaseReleaseSettings()).asConfig()

    return Settings(
      base: iOSBaseSettings(),
      debug: debug,
      release: release
    )
  }
}

enum TMDBSwift {
  static let name = "TMDBSwift"

  static func target() -> Target {
    return Target(
      name: TMDBSwift.name,
      platform: .iOS,
      product: .framework,
      bundleId: "\(baseBundleId).TMDBSwift",
      infoPlist: "TMDBSwift/Info.plist",
      sources: ["TMDBSwift/**"],
      headers: Headers(public: "TMDBSwift/Headers/Public/TMDBSwift.h"),
      settings: settings()
    )
  }

  private static func settings() -> Settings {
    let debug = (debugCodeSigning() + sharedBaseDebugSettings()).asConfig()
    let release = (releaseCodeSigning() + sharedBaseReleaseSettings()).asConfig()

    return Settings(
      base: iOSBaseSettings(),
      debug: debug,
      release: release
    )
  }
}

enum TMDBSwiftTests {
  static let name = "TMDBSwiftTests"

  static func target() -> Target {
    return Target(
      name: TMDBSwiftTests.name,
      platform: .iOS,
      product: .unitTests,
      bundleId: "\(baseBundleId).TMDBSwiftTests",
      infoPlist: "TMDBSwiftTests/Info.plist",
      sources: ["TMDBSwiftTests/**"],
      dependencies: [
        .target(name: TMDBSwiftTestable.name),
        .target(name: TMDBSwift.name)
      ],
      settings: settings()
    )
  }

  private static func settings() -> Settings {
    return Settings(base: iOSBaseSettings())
  }
}

enum TMDBSwiftTestable {
  static let name = "TMDBSwiftTestable"

  static func target() -> Target {
    return Target(
      name: TMDBSwiftTestable.name,
      platform: .iOS,
      product: .framework,
      bundleId: "\(baseBundleId).TMDBSwiftTestable",
      infoPlist: "TMDBSwiftTestable/Info.plist",
      sources: ["TMDBSwiftTestable/**"],
      resources: ["TMDBSwiftTestable/Resources/**/*.{xcassets,png,strings,json}"],
      headers: Headers(public: "TMDBSwiftTestable/Headers/Public/TMDBSwiftTestable.h"),
      dependencies: [
        .target(name: TMDBSwift.name)
      ],
      settings: settings()
    )
  }

  private static func settings() -> Settings {
    let debug = (debugCodeSigning() + sharedBaseDebugSettings()).asConfig()
    let release = (releaseCodeSigning() + sharedBaseReleaseSettings()).asConfig()

    return Settings(
      base: iOSBaseSettings(),
      debug: debug,
      release: release
    )
  }
}

enum TVDBSwift {
  static let name = "TVDBSwift"

  static func target() -> Target {
    return Target(
      name: TVDBSwift.name,
      platform: .iOS,
      product: .framework,
      bundleId: "\(baseBundleId).TVDBSwift",
      infoPlist: "TVDBSwift/Info.plist",
      sources: ["TVDBSwift/**"],
      headers: Headers(public: "TVDBSwift/Headers/Public/TVDBSwift.h"),
      settings: settings()
    )
  }

  private static func settings() -> Settings {
    let debug = (debugCodeSigning() + sharedBaseDebugSettings()).asConfig()
    let release = (releaseCodeSigning() + sharedBaseReleaseSettings()).asConfig()

    return Settings(
      base: iOSBaseSettings(),
      debug: debug,
      release: release
    )
  }
}

enum TVDBSwiftTests {
  static let name = "TVDBSwiftTests"

  static func target() -> Target {
    return Target(
      name: TVDBSwiftTests.name,
      platform: .iOS,
      product: .unitTests,
      bundleId: "\(baseBundleId).TVDBSwiftTests",
      infoPlist: "TVDBSwiftTests/Info.plist",
      sources: ["TVDBSwiftTests/**"],
      dependencies: [
        .target(name: TVDBSwiftTestable.name),
        .target(name: TVDBSwift.name)
      ],
      settings: settings()
    )
  }

  private static func settings() -> Settings {
    return Settings(base: iOSBaseSettings())
  }
}

enum TVDBSwiftTestable {
  static let name = "TVDBSwiftTestable"

  static func target() -> Target {
    return Target(
      name: TVDBSwiftTestable.name,
      platform: .iOS,
      product: .framework,
      bundleId: "\(baseBundleId).TVDBSwiftTestable",
      infoPlist: "TVDBSwiftTestable/Info.plist",
      sources: ["TVDBSwiftTestable/**"],
      resources: ["TVDBSwiftTestable/Resources/**/*.{xcassets,png,strings,json}"],
      headers: Headers(public: "TVDBSwiftTestable/Headers/Public/TVDBSwiftTestable.h"),
      settings: settings()
    )
  }

  private static func settings() -> Settings {
    let debug = (debugCodeSigning() + sharedBaseDebugSettings()).asConfig()
    let release = (releaseCodeSigning() + sharedBaseReleaseSettings()).asConfig()

    return Settings(
      base: iOSBaseSettings(),
      debug: debug,
      release: release
    )
  }
}

enum CouchTrackerUITests {
  static let name = "CouchTrackerUITests"

  static func target() -> Target {
    return Target(
      name: CouchTrackerUITests.name,
      platform: .iOS,
      product: .unitTests,
      bundleId: "\(baseBundleId).CouchTrackerUITests",
      infoPlist: "CouchTrackerUITests/Info.plist",
      sources: ["CouchTrackerUITests/**"],
      dependencies: [
        .target(name: CouchTracker.name),
        .target(name: CouchTrackerAppTestable.name)
      ],
      settings: settings()
    )
  }

  private static func settings() -> Settings {
    return Settings(
      base: [
        "DEVELOPMENT_TEAM": "",
        "TEST_HOST": "$(BUILT_PRODUCTS_DIR)/CouchTracker.app/CouchTracker",
        "BUNDLE_LOADER": "$(TEST_HOST)"
      ] + iOSBaseSettings() + disableCodeSigning()
    )
  }
}

// MARK: - Settings functions

func sharedBaseDebugSettings() -> [String: String] {
  return [
    "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG"
  ]
}

func sharedBaseReleaseSettings() -> [String: String] {
  return [
    "SWIFT_ACTIVE_COMPILATION_CONDITIONS": ""
  ]
}

func iOSBaseSettings() -> [String: String] {
  return [
    "IPHONEOS_DEPLOYMENT_TARGET": miniOSVersion,
    "TARGETED_DEVICE_FAMILY": "1",
    "CODE_SIGN_STYLE": "Manual",
    "DEVELOPMENT_TEAM": "B5RPM7SE3L"
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

func allTargets() -> [Target] {
  return alliOSTargets() + alliOSTestTargets()
}

func alliOSTargets() -> [Target] {
  return [
    CouchTracker.target(),
    CouchTrackerApp.target(),
    CouchTrackerAppTestable.target(),
    CouchTrackerPersistence.target(),
    CouchTrackerDebug.target(),
    CouchTrackerCore.target(),
    CouchTrackerSync.target(),
    TraktSwift.target(),
    TMDBSwift.target(),
    TVDBSwift.target(),
    TraktSwiftTestable.target(),
    TMDBSwiftTestable.target(),
    TVDBSwiftTestable.target()
  ]
}

func alliOSTestTargets() -> [Target] {
  return [
    CouchTrackerUITests.target(),
    TraktSwiftTests.target(),
    TMDBSwiftTests.target(),
    TVDBSwiftTests.target(),
    CouchTrackerCoreTests.target(),
    CouchTrackerSyncTests.target()
  ]
}

// MARK: - Schemes

enum AllTests {
  static let name = "AllTests"

  static func scheme() -> Scheme {
    let allTargetNames = allTargets().map { $0.name }
    let testTargetNames = alliOSTestTargets().map { $0.name }

    return Scheme(
      name: AllTests.name,
      shared: true,
      buildAction: BuildAction(targets: allTargetNames),
      testAction: TestAction(targets: testTargetNames)
    )
  }
}

func allSchemes() -> [Scheme] {
  return [
    AllTests.scheme()
  ]
}

func additionalFiles() -> [FileElement] {
  return [
    "changelog.md",
    "CouchTrackerPlayground.playground",
    "Readme.md",
    ".swiftlint.yml"
  ]
}

// MARK: - Project

let project = Project(
  name: CouchTracker.name,
  targets: allTargets(),
  schemes: allSchemes(),
  additionalFiles: additionalFiles()
)
