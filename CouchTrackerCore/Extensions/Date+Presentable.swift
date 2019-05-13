import Foundation

extension Date {
  public func shortString() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = DefaultBundleProvider.instance.currentLanguage.asLocale
    dateFormatter.dateFormat = CouchTrackerCoreStrings.shortDateFormat()
    dateFormatter.timeZone = NSTimeZone.system
    return dateFormatter.string(from: self)
  }
}
