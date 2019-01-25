import TVDBSwift

enum EpisodeImageUtils {
  static func tvdbBaseURLFor(size: TVDBEpisodeImageSize?) -> URL {
    return (size ?? .normal) == .normal ? TVDB.bannersImageURL : TVDB.smallBannersImageURL
  }

  static func cacheKey(episode: EpisodeImageInput, size: EpisodeImageSizes?) -> Int {
    var hasher = Hasher()
    hasher.combine(HashableEpisodeImageInput(episode))
    size.run { hasher.combine($0) }
    return hasher.finalize()
  }
}
