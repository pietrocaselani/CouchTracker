import TVDBSwift

final class TestableDateProvider: DateProvider {
  var now: Date

  init(now: Date) {
    self.now = now
  }
}
