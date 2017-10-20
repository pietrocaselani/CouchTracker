import ObjectMapper

public final class EpisodeIds: BaseIds {
  public let tvdb: Int
  public let tvrage: Int?

  public init(trakt: Int, tmdb: Int?, imdb: String?, tvdb: Int, tvrage: Int?) {
    self.tvdb = tvdb
    self.tvrage = tvrage
    super.init(trakt: trakt, tmdb: tmdb, imdb: imdb)
  }
  
  public required init(map: Map) throws {
    self.tvdb = try map.value("tvdb")
    self.tvrage = try? map.value("tvrage")
    try super.init(map: map)
  }
  
  public override func mapping(map: Map) {
    self.tvdb >>> map["tvdb"]
    self.tvrage >>> map["tvrage"]
  }
  
  public override var hashValue: Int {
    var hash = super.hashValue ^ tvdb.hashValue
    if let tvrageHash = tvrage?.hashValue {
      hash = hash ^ tvrageHash
    }
    return hash
  }

  public override var description: String {
    return "\(super.description), tvdb: \(tvdb), tvrage: \(String(describing: tvrage))"
  }
}
