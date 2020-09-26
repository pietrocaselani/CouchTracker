import ProjectDescription

// swiftlint:disable file_length

// MARK: - Extensions

func + (lhs: [String: String], rhs: [String: String]) -> [String: String] {
  lhs.merging(rhs) { first, _ in first }
}

extension Dictionary where Key == String, Value == String {
  func asConfig() -> Configuration {
    Configuration(settings: mapValues(SettingValue.init(stringLiteral:)))
  }

  func asSettings() -> SettingsDictionary {
    mapValues(SettingValue.init(stringLiteral:))
  }
}

// MARK: - Common

private func actionSwiftLint() -> TargetAction {
  TargetAction.post(path: "build_phases/swiftlint", arguments: [], name: "SwiftLint")
}

private func commonBuildPhases() -> [TargetAction] {
  [ actionSwiftLint() ]
}

// MARK: - Constants

let baseBundleId = "io.github.pietrocaselani"
let iOSDKSVersion = "13.0"

// MARK: - iOS Target structures

enum CouchTracker {
  static let name = "CouchTracker"
  static func target() -> Target {
    Target(
      name: CouchTracker.name,
      platform: .iOS,
      product: .app,
      bundleId: "\(baseBundleId).couchtracker",
      infoPlist: "CouchTracker/Info.plist",
      sources: ["CouchTracker/**"],
      resources: ["CouchTracker/Resources/**/*.{xcassets,png,strings,json,storyboard}"],
      actions: commonBuildPhases(),
      dependencies: [
        //        .target(name: CouchTrackerApp.name),
        //        .target(name: CouchTrackerPersistence.name),
        //        .target(name: CouchTrackerDebug.name),
        .target(name: CouchTrackerCore.name),
        .target(name: CouchTrackerAppTCA.name),
        .target(name: TMDBSwift.name),
        .target(name: TVDBSwift.name),
        .target(name: TraktSwift.name),
        .package(product: "ComposableArchitecture"),
        .package(product: "RxMoya")
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
}

enum CouchTrackerApp {
  static let name = "CouchTrackerApp"

  static func target() -> Target {
    Target(
      name: CouchTrackerApp.name,
      platform: .iOS,
      product: .framework,
      bundleId: "\(baseBundleId).CouchTrackerApp",
      infoPlist: "CouchTrackerApp/Info.plist",
      sources: ["CouchTrackerApp/**"],
      resources: ["CouchTrackerApp/Resources/**/*.{xcassets,png,strings,json}"],
      headers: Headers(public: "CouchTrackerApp/Headers/Public/CouchTrackerApp.h"),
      actions: commonBuildPhases(),
      dependencies: [
        //        .target(name: CouchTrackerPersistence.name),
        .target(name: CouchTrackerDebug.name),
        .target(name: CouchTrackerCore.name),
        .target(name: CouchTrackerSync.name),
        .target(name: TMDBSwift.name),
        .target(name: TVDBSwift.name),
        .target(name: TraktSwift.name),
        .target(name: SPMLibraries.name)
      ],
      settings: settings()
    )
  }

  private static func settings() -> Settings {
    let debug = (debugCodeSigning() + sharedBaseDebugSettings()).asConfig()
    let release = (releaseCodeSigning() + sharedBaseReleaseSettings()).asConfig()

    return Settings(
      base: iOSBaseSettings().asSettings(),
      debug: debug,
      release: release
    )
  }
}

enum CouchTrackerAppTestable {
  static let name = "CouchTrackerAppTestable"

  static func target() -> Target {
    Target(
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
      base: iOSBaseSettings().asSettings(),
      debug: debug,
      release: release
    )
  }
}

enum CouchTrackerPersistence {
  static let name = "CouchTrackerPersistence"

  static func target() -> Target {
    Target(
      name: CouchTrackerPersistence.name,
      platform: .iOS,
      product: .framework,
      bundleId: "\(baseBundleId).CouchTrackerPersistence",
      infoPlist: "CouchTrackerPersistence/Info.plist",
      sources: ["CouchTrackerPersistence/**"],
      headers: Headers(public: "CouchTrackerPersistence/Headers/Public/CouchTrackerPersistence.h"),
      actions: commonBuildPhases(),
      dependencies: [

      ],
      settings: settings()
    )
  }

  private static func settings() -> Settings {
    let debug = (debugCodeSigning() + sharedBaseDebugSettings()).asConfig()
    let release = (releaseCodeSigning() + sharedBaseReleaseSettings()).asConfig()

    return Settings(
      base: iOSBaseSettings().asSettings(),
      debug: debug,
      release: release
    )
  }
}

enum CouchTrackerDebug {
  static let name = "CouchTrackerDebug"

  static func target() -> Target {
    Target(
      name: CouchTrackerDebug.name,
      platform: .iOS,
      product: .framework,
      bundleId: "\(baseBundleId).CouchTrackerDebug",
      infoPlist: "CouchTrackerDebug/Info.plist",
      sources: ["CouchTrackerDebug/**"],
      headers: Headers(public: "CouchTrackerDebug/Headers/Public/CouchTrackerDebug.h"),
      actions: commonBuildPhases(),
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
      base: iOSBaseSettings().asSettings(),
      debug: debug,
      release: release
    )
  }
}

enum CouchTrackerCore {
  static let name = "CouchTrackerCore"

  static func target() -> Target {
    Target(
      name: CouchTrackerCore.name,
      platform: .iOS,
      product: .framework,
      bundleId: "\(baseBundleId).CouchTrackerCore",
      infoPlist: "CouchTrackerCore/Info.plist",
      sources: ["CouchTrackerCore/**", "CommonSources/**"],
      resources: ["CouchTrackerCore/Resources/**/*.{xcassets,png,strings,json}"],
      headers: Headers(public: "CouchTrackerCore/Headers/Public/CouchTrackerCore.h"),
      actions: commonBuildPhases(),
      dependencies: [
        .target(name: TMDBSwift.name),
        .target(name: TVDBSwift.name),
        .target(name: TraktSwift.name),
        .target(name: SPMLibraries.name)
      ],
      settings: settings()
    )
  }

  private static func settings() -> Settings {
    let debug = (debugCodeSigning() + sharedBaseDebugSettings()).asConfig()
    let release = (releaseCodeSigning() + sharedBaseReleaseSettings()).asConfig()

    return Settings(
      base: iOSBaseSettings().asSettings(),
      debug: debug,
      release: release
    )
  }
}

enum CouchTrackerCoreTests {
  static let name = "CouchTrackerCoreTests"

  static func target() -> Target {
    Target(
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
    Settings(base: iOSBaseSettings().asSettings())
  }
}

enum CouchTrackerSync {
  static let name = "CouchTrackerSync"

  static func target() -> Target {
    Target(
      name: CouchTrackerSync.name,
      platform: .iOS,
      product: .framework,
      bundleId: "\(baseBundleId).CouchTrackerSync",
      infoPlist: "CouchTrackerSync/Info.plist",
      sources: ["CouchTrackerSync/**", "CommonSources/**"],
      headers: Headers(public: "CouchTrackerSync/Headers/Public/CouchTrackerSync.h"),
      actions: commonBuildPhases(),
      dependencies: [
        .target(name: TraktSwift.name),
        .target(name: SPMLibraries.name)
      ],
      settings: settings()
    )
  }

  private static func settings() -> Settings {
    let debug = (debugCodeSigning() + sharedBaseDebugSettings()).asConfig()
    let release = (releaseCodeSigning() + sharedBaseReleaseSettings()).asConfig()

    return Settings(
      base: iOSBaseSettings().asSettings(),
      debug: debug,
      release: release
    )
  }
}

enum CouchTrackerSyncTests {
  static let name = "CouchTrackerSyncTests"

  static func target() -> Target {
    Target(
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
    Settings(base: iOSBaseSettings().asSettings())
  }
}

enum TraktSwift {
  static let name = "TraktSwift"

  static func target() -> Target {
    Target(
      name: TraktSwift.name,
      platform: .iOS,
      product: .framework,
      bundleId: "\(baseBundleId).\(Self.name)",
      infoPlist: .default,
      sources: ["\(Self.name)/Sources/**"],
      headers: Headers(public: "TraktSwift/Headers/Public/TraktSwift.h"),
      actions: commonBuildPhases(),
      dependencies: [
        .target(name: HTTPClient.name)
      ],
      settings: settings()
    )
  }

  private static func settings() -> Settings {
    let debug = (debugCodeSigning() + sharedBaseDebugSettings()).asConfig()
    let release = (releaseCodeSigning() + sharedBaseReleaseSettings()).asConfig()

    return Settings(
      base: iOSBaseSettings().asSettings(),
      debug: debug,
      release: release
    )
  }
}

enum TraktSwiftTests {
  static let name = "TraktSwiftTests"

  static func target() -> Target {
    Target(
      name: TraktSwiftTests.name,
      platform: .iOS,
      product: .unitTests,
      bundleId: "\(baseBundleId).\(Self.name)",
      infoPlist: .default,
      sources: ["\(Self.name)/Sources/**"],
      dependencies: [
        .target(name: TraktSwiftTestable.name),
        .target(name: TraktSwift.name),
        .target(name: HTTPClientTestable.name)
      ],
      settings: settings()
    )
  }

  private static func settings() -> Settings {
    Settings(base: iOSBaseSettings().asSettings())
  }
}

enum TraktSwiftTestable {
  static let name = "TraktSwiftTestable"

  static func target() -> Target {
    Target(
      name: TraktSwiftTestable.name,
      platform: .iOS,
      product: .framework,
      bundleId: "\(baseBundleId).\(Self.name)",
      infoPlist: .default,
      sources: ["\(Self.name)/Sources/**"],
      resources: ["\(Self.name)/Resources/**/*.{xcassets,png,strings,json}"],
      headers: Headers(public: "TraktSwiftTestable/Headers/Public/TraktSwiftTestable.h"),
      actions: commonBuildPhases(),
      dependencies: [
        .target(name: TraktSwift.name),
        .target(name: HTTPClient.name)
      ],
      settings: settings()
    )
  }

  private static func settings() -> Settings {
    let debug = (debugCodeSigning() + sharedBaseDebugSettings()).asConfig()
    let release = (releaseCodeSigning() + sharedBaseReleaseSettings()).asConfig()

    return Settings(
      base: iOSBaseSettings().asSettings(),
      debug: debug,
      release: release
    )
  }
}

enum TMDBSwift {
  static let name = "TMDBSwift"

  static func target() -> Target {
    Target(
      name: TMDBSwift.name,
      platform: .iOS,
      product: .framework,
      bundleId: "\(baseBundleId).\(Self.name)",
      infoPlist: .default,
      sources: ["\(Self.name)/Sources/**"],
      headers: Headers(public: "TMDBSwift/Headers/Public/**/*.h"),
      actions: commonBuildPhases(),
      dependencies: [
        .target(name: HTTPClient.name)
      ],
      settings: settings()
    )
  }

  private static func settings() -> Settings {
    let debug = (debugCodeSigning() + sharedBaseDebugSettings()).asConfig()
    let release = (releaseCodeSigning() + sharedBaseReleaseSettings()).asConfig()

    return Settings(
      base: iOSBaseSettings().asSettings(),
      debug: debug,
      release: release
    )
  }
}

enum TMDBSwiftTests {
  static let name = "TMDBSwiftTests"

  static func target() -> Target {
    Target(
      name: TMDBSwiftTests.name,
      platform: .iOS,
      product: .unitTests,
      bundleId: "\(baseBundleId).TMDBSwiftTests",
      infoPlist: "TMDBSwiftTests/Info.plist",
      sources: ["TMDBSwiftTests/**"],
      dependencies: [
        .target(name: TMDBSwiftTestable.name),
        .target(name: TMDBSwift.name),
        .target(name: HTTPClientTestable.name)
      ],
      settings: settings()
    )
  }

  private static func settings() -> Settings {
    Settings(base: iOSBaseSettings().asSettings())
  }
}

enum TMDBSwiftTestable {
  static let name = "TMDBSwiftTestable"

  static func target() -> Target {
    Target(
      name: TMDBSwiftTestable.name,
      platform: .iOS,
      product: .framework,
      bundleId: "\(baseBundleId).TMDBSwiftTestable",
      infoPlist: "TMDBSwiftTestable/Info.plist",
      sources: ["TMDBSwiftTestable/**"],
      resources: ["TMDBSwiftTestable/Resources/**/*.{xcassets,png,strings,json}"],
      headers: Headers(public: "TMDBSwiftTestable/Headers/Public/TMDBSwiftTestable.h"),
      actions: commonBuildPhases(),
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
      base: iOSBaseSettings().asSettings(),
      debug: debug,
      release: release
    )
  }
}

enum TVDBSwift {
  static let name = "TVDBSwift"

  static func target() -> Target {
    Target(
      name: TVDBSwift.name,
      platform: .iOS,
      product: .framework,
      bundleId: "\(baseBundleId).\(Self.name)",
      infoPlist: .default,
      sources: ["\(Self.name)/Sources/**"],
      headers: Headers(public: "TVDBSwift/Headers/Public/TVDBSwift.h"),
      actions: commonBuildPhases(),
      dependencies: [
        .target(name: HTTPClient.name)
      ],
      settings: settings()
    )
  }

  private static func settings() -> Settings {
    let debug = (debugCodeSigning() + sharedBaseDebugSettings()).asConfig()
    let release = (releaseCodeSigning() + sharedBaseReleaseSettings()).asConfig()

    return Settings(
      base: iOSBaseSettings().asSettings(),
      debug: debug,
      release: release
    )
  }
}

enum TVDBSwiftTests {
  static let name = "TVDBSwiftTests"

  static func target() -> Target {
    Target(
      name: TVDBSwiftTests.name,
      platform: .iOS,
      product: .unitTests,
      bundleId: "\(baseBundleId).\(Self.name)",
      infoPlist: .default,
      sources: ["\(Self.name)/Sources/**"],
      dependencies: [
        .target(name: TVDBSwiftTestable.name),
        .target(name: TVDBSwift.name),
        .target(name: HTTPClientTestable.name),
        .target(name: HTTPClient.name)
      ],
      settings: settings()
    )
  }

  private static func settings() -> Settings {
    Settings(base: iOSBaseSettings().asSettings())
  }
}

enum TVDBSwiftTestable {
  static let name = "TVDBSwiftTestable"

  static func target() -> Target {
    Target(
      name: TVDBSwiftTestable.name,
      platform: .iOS,
      product: .framework,
      bundleId: "\(baseBundleId).\(Self.name)",
      infoPlist: .default,
      sources: ["\(Self.name)/Sources/**"],
      resources: ["\(Self.name)/Resources/**/*.{xcassets,png,strings,json}"],
      headers: Headers(public: "TVDBSwiftTestable/Headers/Public/TVDBSwiftTestable.h"),
      settings: settings()
    )
  }

  private static func settings() -> Settings {
    let debug = (debugCodeSigning() + sharedBaseDebugSettings()).asConfig()
    let release = (releaseCodeSigning() + sharedBaseReleaseSettings()).asConfig()

    return Settings(
      base: iOSBaseSettings().asSettings(),
      debug: debug,
      release: release
    )
  }
}

enum CouchTrackerUITests {
  static let name = "CouchTrackerUITests"

  static func target() -> Target {
    Target(
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
    Settings(
      base: ([
        "DEVELOPMENT_TEAM": "",
        "TEST_HOST": "$(BUILT_PRODUCTS_DIR)/CouchTracker.app/CouchTracker",
        "BUNDLE_LOADER": "$(TEST_HOST)"
      ] + iOSBaseSettings() + disableCodeSigning()).asSettings()
    )
  }
}

enum SPMLibraries {
  static let name = "SPMLibraries"

  static func target() -> Target {
    Target(
      name: "SPMLibraries",
      platform: .iOS,
      product: .framework,
      bundleId: "\(baseBundleId).SPMLibraries",
      infoPlist: .default,
      dependencies: [
        .package(product: "ComposableArchitecture"),
        .package(product: "RxMoya"),
        .package(product: "Alamofire")
      ]
    )
  }
}

enum CouchTrackerAppTCA {
  static let name = "CouchTrackerAppTCA"

  static func target() -> Target {
    Target(
      name: CouchTrackerAppTCA.name,
      platform: .iOS,
      product: .framework,
      productName: CouchTrackerAppTCA.name,
      bundleId: "\(baseBundleId).CouchTrackerAppTCA",
      infoPlist: "CouchTrackerAppTCA/Info.plist",
      sources: ["CouchTrackerAppTCA/**"],
      resources: ["CouchTrackerAppTCA/Resources/**/*.{xcassets,png,strings,json}"],
      headers: Headers(public: "CouchTrackerAppTCA/Headers/Public/CouchTrackerAppTCA.h"),
      actions: commonBuildPhases(),
      dependencies: [
        .target(name: SPMLibraries.name),
        .target(name: TraktSwift.name),
        .target(name: TMDBSwift.name),
        .target(name: TVDBSwift.name),
        .target(name: CouchTrackerSync.name),
        .target(name: CouchTrackerCore.name)
      ],
      settings: settings()
    )
  }

  private static func settings() -> Settings {
    let debug = (debugCodeSigning() + sharedBaseDebugSettings()).asConfig()
    let release = (releaseCodeSigning() + sharedBaseReleaseSettings()).asConfig()

    return Settings(
      base: iOSBaseSettings().asSettings(),
      debug: debug,
      release: release
    )
  }
}

enum HTTPClient {
  static let name = "HTTPClient"

  static func target() -> Target {
    Target(
      name: Self.name,
      platform: .iOS,
      product: .framework,
      productName: Self.name,
      bundleId: "\(baseBundleId).\(Self.name)",
      infoPlist: .default,
      sources: ["\(Self.name)/Sources/**"],
      headers: Headers(public: "HTTPClient/Headers/Public/**/*.h"),
      actions: commonBuildPhases(),
      settings: settings()
    )
  }

  private static func settings() -> Settings {
    let debug = (debugCodeSigning() + sharedBaseDebugSettings()).asConfig()
    let release = (releaseCodeSigning() + sharedBaseReleaseSettings()).asConfig()

    return Settings(
      base: iOSBaseSettings().asSettings(),
      debug: debug,
      release: release
    )
  }
}

enum HTTPClientTests {
  static let name = "HTTPClientTests"

  static func target() -> Target {
    Target(
      name: Self.name,
      platform: .iOS,
      product: .unitTests,
      bundleId: "\(baseBundleId).\(Self.name)",
      infoPlist: .default,
      sources: ["\(Self.name)/Sources/**"],
      dependencies: [
        .target(name: HTTPClient.name),
        .target(name: HTTPClientTestable.name)
      ],
      settings: settings()
    )
  }

  private static func settings() -> Settings {
    Settings(base: iOSBaseSettings().asSettings())
  }
}

enum HTTPClientTestable {
  static let name = "HTTPClientTestable"

  static func target() -> Target {
    Target(
      name: Self.name,
      platform: .iOS,
      product: .framework,
      productName: Self.name,
      bundleId: "\(baseBundleId).\(Self.name)",
      infoPlist: .default,
      sources: ["\(Self.name)/Sources/**"],
      headers: Headers(public: "HTTPClientTestable/Headers/Public/**/*.h"),
      actions: commonBuildPhases(),
      settings: settings()
    )
  }

  private static func settings() -> Settings {
    let debug = (debugCodeSigning() + sharedBaseDebugSettings()).asConfig()
    let release = (releaseCodeSigning() + sharedBaseReleaseSettings()).asConfig()

    return Settings(
      base: iOSBaseSettings().asSettings(),
      debug: debug,
      release: release
    )
  }
}

// MARK: - Settings functions

func sharedBaseDebugSettings() -> [String: String] {
  [
    "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG"
  ]
}

func sharedBaseReleaseSettings() -> [String: String] {
  [
    "SWIFT_ACTIVE_COMPILATION_CONDITIONS": ""
  ]
}

func iOSBaseSettings() -> [String: String] {
  [
    "IPHONEOS_DEPLOYMENT_TARGET": iOSDKSVersion,
    "TARGETED_DEVICE_FAMILY": "1",
    "CODE_SIGN_STYLE": "Manual",
    "DEVELOPMENT_TEAM": "B5RPM7SE3L"
  ]
}

func disableCodeSigning() -> [String: String] {
  ["CODE_SIGN_IDENTITY": ""]
}

func releaseCodeSigning() -> [String: String] {
  ["CODE_SIGN_IDENTITY": "iPhone Distribution"]
}

func debugCodeSigning() -> [String: String] {
  ["CODE_SIGN_IDENTITY": "iPhone Developer"]
}

func allTargets() -> [Target] {
  alliOSTargets() + alliOSTestTargets()
}

func alliOSTargets() -> [Target] {
  [
    CouchTracker.target(),
    CouchTrackerAppTCA.target(),
    CouchTrackerApp.target(),
    CouchTrackerAppTestable.target(),
    //    CouchTrackerPersistence.target(),
    CouchTrackerDebug.target(),
    CouchTrackerCore.target(),
    CouchTrackerSync.target(),
    TraktSwift.target(),
    TMDBSwift.target(),
    TVDBSwift.target(),
    TraktSwiftTestable.target(),
    TMDBSwiftTestable.target(),
    TVDBSwiftTestable.target(),
    HTTPClient.target(),
    HTTPClientTestable.target(),
    SPMLibraries.target()
  ]
}

func alliOSTestTargets() -> [Target] {
  [
    HTTPClientTests.target(),
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
    let allTargetNames = allTargets().map { TargetReference(stringLiteral: $0.name) }
    let testTargetNames = alliOSTestTargets().map { TestableTarget(stringLiteral: $0.name) }

    return Scheme(
      name: AllTests.name,
      shared: true,
      buildAction: BuildAction(targets: allTargetNames),
      testAction: TestAction(targets: testTargetNames)
    )
  }
}

func allSchemes() -> [Scheme] {
  [
    AllTests.scheme()
  ]
}

func additionalFiles() -> [FileElement] {
  [
    "CouchTrackerCore-sourcery.yml",
    "CouchTrackerSync-sourcery.yml",
    ".circleci",
    ".codecov.yml",
    ".editorconfig",
    ".gitignore",
    ".swift-version",
    ".swiftlint.yml",
    ".tuist-version",
    "Brewfile",
    "Gemfile",
    "Podfile",
    "Readme.md",
    "SourceryTemplates",
    "build_phases",
    "changelog.md",
    "fastlane",
    "scripts",
    "setup.sh",
    "sonar-project.properties",
    "CouchTrackerPlayground.playground"
  ]
}

func swiftPackages() -> [Package] {
  [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", .upToNextMajor(from: "0.8.0"))
    //        .package(url: "https://github.com/uias/Tabman", .upToNextMajor(from: "2.9.1"))
    //        .package(url: "https://github.com/RxSwiftCommunity/RxRealm", .upToNextMajor(from: "3.1.0")),
    //        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", .upToNextMajor(from: "1.8.2")),
    //        .package(url: "https://github.com/onevcat/Kingfisher", .upToNextMajor(from: "5.15.0")),
    //        .package(url: "https://github.com/ReactiveX/RxSwift", .upToNextMajor(from: "5.1.1")),
    //        .package(url: "https://github.com/RxSwiftCommunity/RxDataSources", .upToNextMajor(from: "4.0.1")),
    //        .package(url: "https://github.com/RxSwiftCommunity/RxNimble", .upToNextMajor(from: "4.7.2")),
    //  .local(path: "Swift-Packages/TrendingMovies")
  ]
}

// MARK: - Project

let project = Project(
  name: CouchTracker.name,
  organizationName: "Pietro Caselani",
  packages: swiftPackages(),
  targets: allTargets(),
  schemes: allSchemes(),
  additionalFiles: additionalFiles()
)
