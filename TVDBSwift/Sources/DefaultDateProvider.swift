import Foundation

final class DefaultDateProvider: DateProvider {
  var now: Date { Date() }
}
