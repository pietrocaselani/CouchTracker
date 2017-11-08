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
    let trakt = Trakt(clientId: Secrets.Trakt.clientId,
                       clientSecret: Secrets.Trakt.clientSecret,
                       redirectURL: Secrets.Trakt.redirectURL)
    self.tmdb = TMDBWrapperProvider(tmdb: TMDB(apiKey: Secrets.TMDB.apiKey))
    self.tvdb = TVDBWrapperProvider(tvdb: TVDB(apiKey: Secrets.TVDB.apiKey))

//    trakt.addPlugin(NetworkLoggerPlugin(verbose: true, cURL: false))
    trakt.addPlugin(ResponseWriterMoyaPlugin())
    trakt.addPlugin(NoCacheMoyaPlugin())

    let traktLoginStore = TraktLoginStore(trakt: trakt)

    self.loginObservable = traktLoginStore
    self.defaultOutput = traktLoginStore.loginOutput

    self.trakt = TraktWrapperProvider(trakt: trakt, loginObservable: traktLoginStore)

    let uglyCache = AnyCache(UglyMemoryCache())

    self.memoryCache = uglyCache
    self.diskCache = uglyCache
  }
}
