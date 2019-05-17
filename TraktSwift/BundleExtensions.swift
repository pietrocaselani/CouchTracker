import Foundation

extension Bundle {
  static var testable: Bundle {
    // swiftlint:disable force_unwrapping
    return Bundle(identifier: "io.github.pietrocaselani.TraktSwiftTestable")!
  }
}
