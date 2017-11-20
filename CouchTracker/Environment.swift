import TraktSwift
import TMDBSwift
import TVDBSwift
import Moya

final class Environment {
  static let instance = Environment()
  let trakt: TraktProvider
  let tmdb: TMDBProvider
  let tvdb: TVDBProvider
  let loginObservable: TraktLoginObservable
  let defaultOutput: TraktLoginOutput
  let diskCache: AnyCache<Int, NSData>
  let memoryCache: AnyCache<Int, NSData>

  private init() {
    let moyaQueue = DispatchQueue(label: "CallbackQueue", qos: .background)

    let traktBuilder = TraktBuilder {
      $0.clientId = Secrets.Trakt.clientId
      $0.clientSecret = Secrets.Trakt.clientSecret
      $0.redirectURL = Secrets.Trakt.redirectURL
      $0.callbackQueue = moyaQueue
      $0.plugins = [NoCacheMoyaPlugin(), ResponseWriterMoyaPlugin()]
    }

    let tvdbBuilder = TVDBBuilder {
      $0.apiKey = Secrets.TVDB.apiKey
      $0.callbackQueue = moyaQueue
    }

    let trakt = Trakt(builder: traktBuilder)

    self.trakt = trakt
    self.tmdb = TMDB(apiKey: Secrets.TMDB.apiKey)
    self.tvdb = TVDB(builder: tvdbBuilder)

    let traktLoginStore = TraktLoginStore(trakt: trakt)

    self.loginObservable = traktLoginStore
    self.defaultOutput = traktLoginStore.loginOutput

    let uglyCache = AnyCache(UglyMemoryCache())

    self.memoryCache = uglyCache
    self.diskCache = uglyCache
  }
}
