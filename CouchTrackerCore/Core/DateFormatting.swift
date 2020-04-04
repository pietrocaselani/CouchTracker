import Foundation

public enum DateFormatting {
  public static func shortString(
    localeProvider: () -> Locale = { DefaultBundleProvider.instance.currentLanguage.asLocale },
    timeZoneProvider: () -> TimeZone = { NSTimeZone.system },
    date: Date
  ) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = localeProvider()
    dateFormatter.dateFormat = CouchTrackerCoreStrings.shortDateFormat()
    dateFormatter.timeZone = timeZoneProvider()
    return dateFormatter.string(from: date)
  }
}

extension Date {
  public func shortString(
    localeProvider: () -> Locale = { DefaultBundleProvider.instance.currentLanguage.asLocale },
    timeZoneProvider: () -> TimeZone = { NSTimeZone.system }
  ) -> String {
    DateFormatting.shortString(
      localeProvider: localeProvider,
      timeZoneProvider: timeZoneProvider,
      date: self
    )
  }
}
