import Foundation
import TVDBSwift

enum EpisodeImageUtils {
  static func tvdbBaseURLFor(size: TVDBEpisodeImageSize?) -> URL {
    (size ?? .normal) == .normal ? TVDB.bannersImageURL : TVDB.smallBannersImageURL
  }

  static func cacheKey(episode: EpisodeImageInput, size: EpisodeImageSizes?) -> Int {
    var hasher = Hasher()
    hasher.combine(HashableEpisodeImageInput(episode))
    hasher.combine(size)
    return hasher.finalize()
  }
}
