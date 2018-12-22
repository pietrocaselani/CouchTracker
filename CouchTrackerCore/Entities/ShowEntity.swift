import Foundation
import TraktSwift

public struct ShowEntity: Hashable, Codable {
  public let ids: ShowIds
  public let title: String?
  public let overview: String?
  public let network: String?
  public let genres: [Genre]
  public let status: Status?
  public let firstAired: Date?

  public init(ids: ShowIds, title: String?, overview: String?,
              network: String?, genres: [Genre], status: Status?, firstAired: Date?) {
    self.ids = ids
    self.title = title
    self.overview = overview
    self.network = network
    self.genres = genres
    self.status = status
    self.firstAired = firstAired
  }

  public var hashValue: Int {
    var hash = ids.hashValue
    title.run { hash ^= $0.hashValue }
    overview.run { hash ^= $0.hashValue }
    status.run { hash ^= $0.hashValue }
    firstAired.run { hash ^= $0.hashValue }
    network.run { hash ^= $0.hashValue }
    genres.forEach { hash ^= $0.hashValue }
    return hash
  }

  public static func == (lhs: ShowEntity, rhs: ShowEntity) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
