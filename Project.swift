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
    return Target(name: CouchTracker.name,
                  platform: .iOS,
                  product: .app,
                  bundleId: "\(baseBundleId).couchtracker",
                  infoPlist: "CouchTracker/Info.plist",
                  sources: ["CouchTracker/**"],
                  resources: ["CouchTracker/Resources/**/*.{xcassets,png,strings,json,storyboard}"],
                  actions: buildPhases(),
                  dependencies: [
                    .target(name: "CouchTrackerApp"),
                    .target(name: "CouchTrackerPersistence"),
                    .target(name: "CouchTrackerDebug"),
                    .target(name: "CouchTrackerCore-iOS"),
                    .target(name: "TMDBSwift-iOS"),
                    .target(name: "TVDBSwift-iOS"),
                    .target(name: "TraktSwift-iOS")
                  ],
                  settings: settings())
  }

  private static func settings() -> Settings {
    let debug = [
      "PROVISIONING_PROFILE_SPECIFIER": "match Development io.github.pietrocaselani.couchtracker",
      "OTHER_SWIFT_FLAGS": "$(inherited) -D COCOAPODS -D DEBUG -Xfrontend -warn-long-expression-type-checking=100 -Xfrontend -warn-long-function-bodies=100"
    ] + iOSBaseSettings() + debugCodeSigning()

    let release = [
      "PROVISIONING_PROFILE_SPECIFIER": "match AppStore io.github.pietrocaselani.couchtracker",
      "OTHER_SWIFT_FLAGS": "$(inherited) -D COCOAPODS"
    ] + iOSBaseSettings() + releaseCodeSigning()

    return Settings(debug: debug.asConfig(), release: release.asConfig())
  }

  private static func buildPhases() -> [TargetAction] {
    return [
      TargetAction.post(path: "build_phases/swiftlint", arguments: [], name: "Swiftlint"),
      TargetAction.post(path: "build_phases/swiftformat", arguments: [], name: "Swiftformat")
    ]
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
                  resources: ["CouchTrackerApp/Resources/**/*.{xcassets,png,strings,json}"],
                  headers: Headers(public: "CouchTrackerApp/Headers/Public/CouchTrackerApp.h"),
                  dependencies: [
                    .target(name: "CouchTrackerPersistence"),
                    .target(name: "CouchTrackerDebug"),
                    .target(name: "CouchTrackerCore-iOS"),
                    .target(name: "TMDBSwift-iOS"),
                    .target(name: "TVDBSwift-iOS"),
                    .target(name: "TraktSwift-iOS")
                  ],
                  settings: settings())
  }

  private static func settings() -> Settings {
    return Settings(base: iOSBaseSettings(),
                    debug: debugCodeSigning().asConfig(),
                    release: releaseCodeSigning().asConfig())
  }
}

enum CouchTrackerAppTestable {
  static let name = "CouchTrackerAppTestable"

  static func target() -> Target {
    return Target(name: CouchTrackerAppTestable.name,
                  platform: .iOS,
                  product: .framework,
                  bundleId: "\(baseBundleId).CouchTrackerAppTestable",
                  infoPlist: "CouchTrackerAppTestable/Info.plist",
                  sources: ["CouchTrackerAppTestable/**"],
                  headers: Headers(public: "CouchTrackerAppTestable/Headers/Public/CouchTrackerAppTestable.h"),
                  dependencies: [
                    .target(name: CouchTrackerCoreiOS.name),
                    .target(name: CouchTrackerApp.name)
                  ],
                  settings: settings())
  }

  private static func settings() -> Settings {
    return Settings(base: iOSBaseSettings(),
                    debug: debugCodeSigning().asConfig(),
                    release: releaseCodeSigning().asConfig())
  }
}

enum CouchTrackerPersistence {
  static let name = "CouchTrackerPersistence"

  static func target() -> Target {
    return Target(name: CouchTrackerPersistence.name,
                  platform: .iOS,
                  product: .framework,
                  bundleId: "\(baseBundleId).CouchTrackerPersistence",
                  infoPlist: "CouchTrackerPersistence/Info.plist",
                  sources: ["CouchTrackerPersistence/**"],
                  headers: Headers(public: "CouchTrackerPersistence/Headers/Public/CouchTrackerPersistence.h"),
                  settings: settings())
  }

  private static func settings() -> Settings {
    return Settings(base: iOSBaseSettings(),
                    debug: debugCodeSigning().asConfig(),
                    release: releaseCodeSigning().asConfig())
  }
}

enum CouchTrackerDebug {
  static let name = "CouchTrackerDebug"

  static func target() -> Target {
    return Target(name: CouchTrackerDebug.name,
                  platform: .iOS,
                  product: .framework,
                  bundleId: "\(baseBundleId).CouchTrackerDebug",
                  infoPlist: "CouchTrackerDebug/Info.plist",
                  sources: ["CouchTrackerDebug/**"],
                  headers: Headers(public: "CouchTrackerDebug/Headers/Public/CouchTrackerDebug.h"),
                  dependencies: [
                    .target(name: CouchTrackerCoreiOS.name)
                  ],
                  settings: settings())
  }

  private static func settings() -> Settings {
    return Settings(base: iOSBaseSettings(),
                    debug: debugCodeSigning().asConfig(),
                    release: releaseCodeSigning().asConfig())
  }
}

enum CouchTrackerCoreiOS {
  static let name = "CouchTrackerCore-iOS"

  static func target() -> Target {
    return Target(name: CouchTrackerCoreiOS.name,
                  platform: .iOS,
                  product: .framework,
                  bundleId: "\(baseBundleId).CouchTrackerCore-iOS",
                  infoPlist: "CouchTrackerCore-iOS/Info.plist",
                  sources: ["CouchTrackerCore/**"],
                  resources: ["CouchTrackerCore/Resources/**/*.{xcassets,png,strings,json}"],
                  headers: Headers(public: "CouchTrackerCore-iOS/Headers/Public/CouchTrackerCore_iOS.h"),
                  dependencies: [
                    .target(name: TMDBSwiftiOS.name),
                    .target(name: TVDBSwiftiOS.name),
                    .target(name: TraktSwiftiOS.name)
                  ],
                  settings: settings())
  }

  private static func settings() -> Settings {
    return Settings(base: iOSBaseSettings() + ["PRODUCT_NAME": "CouchTrackerCore"],
                    debug: debugCodeSigning().asConfig(),
                    release: releaseCodeSigning().asConfig())
  }
}

enum TraktSwiftiOS {
  static let name = "TraktSwift-iOS"

  static func target() -> Target {
    return Target(name: TraktSwiftiOS.name,
                  platform: .iOS,
                  product: .framework,
                  bundleId: "\(baseBundleId).TraktSwift-iOS",
                  infoPlist: "TraktSwift-iOS/Info.plist",
                  sources: ["TraktSwift/**"],
                  headers: Headers(public: "TraktSwift-iOS/Headers/Public/TraktSwift_iOS.h"),
                  settings: settings())
  }

  private static func settings() -> Settings {
    return Settings(base: iOSBaseSettings() + ["PRODUCT_NAME": "TraktSwift"],
                    debug: debugCodeSigning().asConfig(),
                    release: releaseCodeSigning().asConfig())
  }
}

enum TMDBSwiftiOS {
  static let name = "TMDBSwift-iOS"

  static func target() -> Target {
    return Target(name: TMDBSwiftiOS.name,
                  platform: .iOS,
                  product: .framework,
                  bundleId: "\(baseBundleId).TMDBSwift-iOS",
                  infoPlist: "TMDBSwift-iOS/Info.plist",
                  sources: ["TMDBSwift/**"],
                  headers: Headers(public: "TMDBSwift-iOS/Headers/Public/TMDBSwift_iOS.h"),
                  settings: settings())
  }

  private static func settings() -> Settings {
    return Settings(base: iOSBaseSettings() + ["PRODUCT_NAME": "TMDBSwift"],
                    debug: debugCodeSigning().asConfig(),
                    release: releaseCodeSigning().asConfig())
  }
}

enum TVDBSwiftiOS {
  static let name = "TVDBSwift-iOS"

  static func target() -> Target {
    return Target(name: TVDBSwiftiOS.name,
                  platform: .iOS,
                  product: .framework,
                  bundleId: "\(baseBundleId).TVDBSwift-iOS",
                  infoPlist: "TVDBSwift-iOS/Info.plist",
                  sources: ["TVDBSwift/**"],
                  headers: Headers(public: "TVDBSwift-iOS/Headers/Public/TVDBSwift_iOS.h"),
                  settings: settings())
  }

  private static func settings() -> Settings {
    return Settings(base: iOSBaseSettings() + ["PRODUCT_NAME": "TVDBSwift"],
                    debug: debugCodeSigning().asConfig(),
                    release: releaseCodeSigning().asConfig())
  }
}

// MARK: - macOS Target structures

enum CouchTrackerCore {
  static let name = "CouchTrackerCore"

  static func target() -> Target {
    return Target(name: CouchTrackerCore.name,
                  platform: .macOS,
                  product: .framework,
                  bundleId: "\(baseBundleId).CouchTrackerCore",
                  infoPlist: "CouchTrackerCore/Info.plist",
                  sources: ["CouchTrackerCore/**"],
                  resources: ["CouchTrackerCore/Resources/**/*.{strings}"],
                  headers: Headers(public: "CouchTrackerCore/Headers/Public/CouchTrackerCore.h"),
                  dependencies: [
                    .target(name: TMDBSwift.name),
                    .target(name: TVDBSwift.name),
                    .target(name: TraktSwift.name)
                  ],
                  settings: settings())
  }

  private static func settings() -> Settings {
    return Settings(base: macOSBaseSettings())
  }
}

enum TraktSwift {
  static let name = "TraktSwift"

  static func target() -> Target {
    return Target(name: TraktSwift.name,
                  platform: .macOS,
                  product: .framework,
                  bundleId: "\(baseBundleId).TraktSwift",
                  infoPlist: "TraktSwift/Info.plist",
                  sources: ["TraktSwift/**"],
                  headers: Headers(public: "TraktSwift/Headers/Public/TraktSwift.h"),
                  settings: settings())
  }

  private static func settings() -> Settings {
    return Settings(base: macOSBaseSettings())
  }
}

enum TraktSwiftTestable {
  static let name = "TraktSwiftTestable"

  static func target() -> Target {
    return Target(name: TraktSwiftTestable.name,
                  platform: .macOS,
                  product: .framework,
                  bundleId: "\(baseBundleId).TraktSwiftTestable",
                  infoPlist: "TraktSwiftTestable/Info.plist",
                  sources: ["TraktSwiftTestable/**"],
                  resources: ["TraktSwiftTestable/Resources/**/*.{xcassets,png,strings,json}"],
                  headers: Headers(public: "TraktSwiftTestable/Headers/Public/TraktSwiftTestable.h"),
                  dependencies: [
                    .target(name: TraktSwift.name)
                  ],
                  settings: settings())
  }

  private static func settings() -> Settings {
    return Settings(base: macOSBaseSettings())
  }
}

enum TMDBSwift {
  static let name = "TMDBSwift"

  static func target() -> Target {
    return Target(name: TMDBSwift.name,
                  platform: .macOS,
                  product: .framework,
                  bundleId: "\(baseBundleId).TMDBSwift",
                  infoPlist: "TMDBSwift/Info.plist",
                  sources: ["TMDBSwift/**"],
                  headers: Headers(public: "TMDBSwift/Headers/Public/TMDBSwift.h"),
                  settings: settings())
  }

  private static func settings() -> Settings {
    return Settings(base: macOSBaseSettings())
  }
}

enum TMDBSwiftTestable {
  static let name = "TMDBSwiftTestable"

  static func target() -> Target {
    return Target(name: TMDBSwiftTestable.name,
                  platform: .macOS,
                  product: .framework,
                  bundleId: "\(baseBundleId).TMDBSwiftTestable",
                  infoPlist: "TMDBSwiftTestable/Info.plist",
                  sources: ["TMDBSwiftTestable/**"],
                  resources: ["TMDBSwiftTestable/Resources/**/*.{xcassets,png,strings,json}"],
                  headers: Headers(public: "TMDBSwiftTestable/Headers/Public/TMDBSwiftTestable.h"),
                  dependencies: [
                    .target(name: TMDBSwift.name)
                  ],
                  settings: settings())
  }

  private static func settings() -> Settings {
    return Settings(base: macOSBaseSettings())
  }
}

enum TVDBSwift {
  static let name = "TVDBSwift"

  static func target() -> Target {
    return Target(name: TVDBSwift.name,
                  platform: .macOS,
                  product: .framework,
                  bundleId: "\(baseBundleId).TVDBSwift",
                  infoPlist: "TVDBSwift/Info.plist",
                  sources: ["TVDBSwift/**"],
                  headers: Headers(public: "TVDBSwift/Headers/Public/TVDBSwift.h"),
                  settings: settings())
  }

  private static func settings() -> Settings {
    return Settings(base: macOSBaseSettings())
  }
}

enum TVDBSwiftTestable {
  static let name = "TVDBSwiftTestable"

  static func target() -> Target {
    return Target(name: TVDBSwiftTestable.name,
                  platform: .macOS,
                  product: .framework,
                  bundleId: "\(baseBundleId).TVDBSwiftTestable",
                  infoPlist: "TVDBSwiftTestable/Info.plist",
                  sources: ["TVDBSwiftTestable/**"],
                  resources: ["TVDBSwiftTestable/Resources/**/*.{xcassets,png,strings,json}"],
                  headers: Headers(public: "TVDBSwiftTestable/Headers/Public/TVDBSwiftTestable.h"),
                  settings: settings())
  }

  private static func settings() -> Settings {
    return Settings(base: macOSBaseSettings())
  }
}

// MARK: - Tests Target structures

enum TraktSwiftTests {
  static let name = "TraktSwiftTests"

  static func target() -> Target {
    return Target(name: TraktSwiftTests.name,
                  platform: .macOS,
                  product: .unitTests,
                  bundleId: "\(baseBundleId).TraktSwiftTests",
                  infoPlist: "TraktSwiftTests/Info.plist",
                  sources: ["TraktSwiftTests/**"],
                  dependencies: [
                    .target(name: TraktSwiftTestable.name),
                    .target(name: TraktSwift.name)
                  ],
                  settings: settings())
  }

  private static func settings() -> Settings {
    return Settings(base: macOSBaseSettings() + macOSTestBaseSettings())
  }
}

enum TMDBSwiftTests {
  static let name = "TMDBSwiftTests"

  static func target() -> Target {
    return Target(name: TMDBSwiftTests.name,
                  platform: .macOS,
                  product: .unitTests,
                  bundleId: "\(baseBundleId).TMDBSwiftTests",
                  infoPlist: "TMDBSwiftTests/Info.plist",
                  sources: ["TMDBSwiftTests/**"],
                  dependencies: [
                    .target(name: TMDBSwiftTestable.name),
                    .target(name: TMDBSwift.name)
                  ],
                  settings: settings())
  }

  private static func settings() -> Settings {
    return Settings(base: macOSBaseSettings() + macOSTestBaseSettings())
  }
}

enum TVDBSwiftTests {
  static let name = "TVDBSwiftTests"

  static func target() -> Target {
    return Target(name: TVDBSwiftTests.name,
                  platform: .macOS,
                  product: .unitTests,
                  bundleId: "\(baseBundleId).TVDBSwiftTests",
                  infoPlist: "TVDBSwiftTests/Info.plist",
                  sources: ["TVDBSwiftTests/**"],
                  dependencies: [
                    .target(name: TVDBSwiftTestable.name),
                    .target(name: TVDBSwift.name)
                  ],
                  settings: settings())
  }

  private static func settings() -> Settings {
    return Settings(base: macOSBaseSettings() + macOSTestBaseSettings())
  }
}

enum CouchTrackerCoreTests {
  static let name = "CouchTrackerCoreTests"

  static func target() -> Target {
    return Target(name: CouchTrackerCoreTests.name,
                  platform: .macOS,
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
                  settings: settings())
  }

  private static func settings() -> Settings {
    return Settings(base: macOSBaseSettings() + macOSTestBaseSettings())
  }
}

enum CouchTrackerUITests {
  static let name = "CouchTrackerUITests"

  static func target() -> Target {
    return Target(name: CouchTrackerUITests.name,
                  platform: .iOS,
                  product: .unitTests,
                  bundleId: "\(baseBundleId).CouchTrackerUITests",
                  infoPlist: "CouchTrackerUITests/Info.plist",
                  sources: ["CouchTrackerUITests/**"],
                  dependencies: [
                    .target(name: CouchTracker.name),
                    .target(name: CouchTrackerAppTestable.name)
                  ],
                  settings: settings())
  }

  private static func settings() -> Settings {
    return Settings(base: [
      "DEVELOPMENT_TEAM": "",
      "TEST_HOST": "$(BUILT_PRODUCTS_DIR)/CouchTracker.app/CouchTracker",
      "BUNDLE_LOADER": "$(TEST_HOST)"
    ] + iOSBaseSettings() + disableCodeSigning())
  }
}

// MARK: - Settings functions

func macOSBaseSettings() -> [String: String] {
  return [
    "MACOSX_DEPLOYMENT_TARGET": minmacOSVersion,
    "CODE_SIGN_STYLE": "Manual",
    "DEVELOPMENT_TEAM": ""
  ] + disableCodeSigning()
}

func macOSTestBaseSettings() -> [String: String] {
  return [
    "EXPANDED_CODE_SIGN_IDENTITY": "-",
    "EXPANDED_CODE_SIGN_IDENTITY_NAME": "-"
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
  return [
    CouchTracker.target(),
    CouchTrackerApp.target(),
    CouchTrackerAppTestable.target(),
    CouchTrackerPersistence.target(),
    CouchTrackerDebug.target(),
    CouchTrackerCoreiOS.target(),
    TraktSwiftiOS.target(),
    TMDBSwiftiOS.target(),
    TVDBSwiftiOS.target(),
    CouchTrackerCore.target(),
    TraktSwift.target(),
    TraktSwiftTestable.target(),
    TMDBSwift.target(),
    TMDBSwiftTestable.target(),
    TVDBSwift.target(),
    TVDBSwiftTestable.target(),
    TraktSwiftTests.target(),
    TMDBSwiftTests.target(),
    TVDBSwiftTests.target(),
    CouchTrackerCoreTests.target(),
    CouchTrackerUITests.target()
  ]
}

// MARK: - Schemes

enum TVDBSwiftScheme {
  static let name = "TVDBSwift"

  static func scheme() -> Scheme {
    return Scheme(name: TVDBSwiftScheme.name,
                  shared: true,
                  buildAction: BuildAction(targets: [TVDBSwift.name, TVDBSwiftTests.name]),
                  testAction: TestAction(targets: [TVDBSwiftTests.name]))
  }
}

enum TMDBSwiftScheme {
  static let name = "TMDBSwift"

  static func scheme() -> Scheme {
    return Scheme(name: TMDBSwiftScheme.name,
                  shared: true,
                  buildAction: BuildAction(targets: [TMDBSwift.name, TMDBSwiftTests.name]),
                  testAction: TestAction(targets: [TMDBSwiftTests.name]))
  }
}

func allSchemes() -> [Scheme] {
  return [
    TVDBSwiftScheme.scheme(),
    TMDBSwiftScheme.scheme()
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

let project = Project(name: CouchTracker.name,
                      targets: allTargets(),
                      additionalFiles: additionalFiles())
