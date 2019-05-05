import Foundation
import TraktSwift

public struct MovieEntity: Hashable {
  public let ids: MovieIds
  public let title: String?
  public let genres: [Genre]?
  public let tagline: String?
  public let overview: String?
  public let releaseDate: Date?
  public let watchedAt: Date?
}
