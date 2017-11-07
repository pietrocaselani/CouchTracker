import TVDBSwift
import Moya

final class TVDBWrapperProvider: TVDBProvider {
  private let tvdb: TVDB

  var episodes: MoyaProvider<Episodes>

  init(tvdb: TVDB) {
    self.tvdb = tvdb

    self.episodes = tvdb.episodes
  }
}
