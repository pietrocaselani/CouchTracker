import Foundation
import ObjectMapper

public final class BaseEpisode: ImmutableMappable, Hashable {
  public let number: Int
  public let collectedAt: Date?
  public let plays: Int?
  public let lastWatchedAt: Date?
  public let completed: Bool?
  
  public init(map: Map) throws {
    self.number = try map.value("number")
    self.collectedAt = try? map.value("collected_at", using: TraktDateTransformer.dateTimeTransformer)
    self.lastWatchedAt = try? map.value("last_watched_at", using: TraktDateTransformer.dateTimeTransformer)
    self.plays = try? map.value("plays")
    self.completed = try? map.value("completed")
  }
  
  public var hashValue: Int {
    var hash = number.hashValue
    
    if let collectedAtHash = collectedAt?.hashValue {
      hash = hash ^ collectedAtHash
    }
    
    if let playsHash = plays?.hashValue {
      hash = hash ^ playsHash
    }
    
    if let lastWatchedAtHash = lastWatchedAt?.hashValue {
      hash = hash ^ lastWatchedAtHash
    }
    
    if let completedHash = completed?.hashValue {
      hash = hash ^ completedHash
    }
    
    return hash
  }
  
  public static func == (lhs: BaseEpisode, rhs: BaseEpisode) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
