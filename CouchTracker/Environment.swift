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
    let traktQueue = DispatchQueue(label: "CallbackQueue", qos: .background)

    let traktBuilder = TraktBuilder {
      $0.clientId = Secrets.Trakt.clientId
      $0.clientSecret = Secrets.Trakt.clientSecret
      $0.redirectURL = Secrets.Trakt.redirectURL
      $0.callbackQueue = traktQueue
      $0.plugins = [NoCacheMoyaPlugin(), ResponseWriterMoyaPlugin()]
    }

    let trakt = Trakt(builder: traktBuilder)
    self.tmdb = TMDBWrapperProvider(tmdb: TMDB(apiKey: Secrets.TMDB.apiKey))
    self.tvdb = TVDBWrapperProvider(tvdb: TVDB(apiKey: Secrets.TVDB.apiKey))

    let traktLoginStore = TraktLoginStore(trakt: trakt)

    self.trakt = trakt

    self.loginObservable = traktLoginStore
    self.defaultOutput = traktLoginStore.loginOutput

    let uglyCache = AnyCache(UglyMemoryCache())

    self.memoryCache = uglyCache
    self.diskCache = uglyCache
  }
}
