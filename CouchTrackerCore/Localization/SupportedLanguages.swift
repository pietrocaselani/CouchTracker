import Foundation

public enum SupportedLanguages: String, Hashable, CaseIterable {
  case englishUS = "en_US"
  case portugueseBR = "pt_BR"

  public var asLocale: Locale {
    Locale(identifier: rawValue)
  }
}
