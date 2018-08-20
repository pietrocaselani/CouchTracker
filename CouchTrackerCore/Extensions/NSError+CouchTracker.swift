import Foundation

extension NSError {
  public static let couchTrackerDomain = "io.github.pietrocaselani.CouchTracker"

  public enum Codes: Int {
    case selfIsDead
  }

  public convenience init(code: Codes, userInfo: [String: Any]?) {
    self.init(domain: NSError.couchTrackerDomain, code: code.rawValue, userInfo: userInfo)
  }

  public convenience init(code: Codes) {
    self.init(code: code, userInfo: nil)
  }

  public convenience init(code: Codes, localizedMessage: String) {
    self.init(code: code, userInfo: [NSLocalizedDescriptionKey: localizedMessage])
  }
}
