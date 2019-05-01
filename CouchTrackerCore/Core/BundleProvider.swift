import Foundation

final class BundleProvider {
  static let testing = NSClassFromString("XCTestCase") != nil

  private init() {
    fatalError("No instances for you!")
  }

  static var provide: Bundle {
    guard testing else {
      return Bundle.main
    }

    return Bundle(identifier: "io.github.pietrocaselani.CouchTrackerCoreTests")!
  }
}
