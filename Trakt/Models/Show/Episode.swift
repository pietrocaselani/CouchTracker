import Foundation
import ObjectMapper

public final class Episode: StandardMediaEntity {
  public let season: Int
  public let number: Int
  public let ids: EpisodeIds
  public let absoluteNumber: Int?
  public let firstAired: Date?
  public let runtime: Int?
  
  public required init(map: Map) throws {
    self.season = try map.value("season")
    self.number = try map.value("number")
    self.ids = try map.value("ids")
    self.absoluteNumber = try? map.value("number_abs")
    self.firstAired = try? map.value("first_aired", using: TraktDateTransformer.dateTimeTransformer)
    self.runtime = try? map.value("runtime")
    try super.init(map: map)
  }
  
  public override var hashValue: Int {
    var hash = super.hashValue ^ season.hashValue ^ number.hashValue ^ ids.hashValue
    
    if let absoluteNumberHash = absoluteNumber?.hashValue {
      hash = hash ^ absoluteNumberHash
    }
    
    if let firstAiredHash = firstAired?.hashValue {
      hash = hash ^ firstAiredHash
    }
    
    return hash
  }
}
