import ObjectMapper

public final class TrendingShow: BaseTrendingEntity {
  public let show: Show
  
  public required init(map: Map) throws {
    self.show = try map.value("show")
    try super.init(map: map)
  }
  
  public override var hashValue: Int {
    return super.hashValue ^ show.hashValue
  }
}
