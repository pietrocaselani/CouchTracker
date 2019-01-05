import TraktSwift

public enum SearchResultType: Hashable {
  case movie(movie: Movie)
  case show(show: Show)
}

public struct SearchResultEntity: Hashable {
  public let score: Double?
  public let type: SearchResultType

  public init(score: Double?, type: SearchResultType) {
    self.score = score
    self.type = type
  }
}
