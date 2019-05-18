import Foundation

public enum SupportedLanguages: String, Hashable, CaseIterable {
  case englishUS = "en_US"
  case portugueseBR = "pt_BR"

  var asLocale: Locale {
    return Locale(identifier: rawValue)
  }
}
