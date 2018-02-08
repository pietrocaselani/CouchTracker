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
  let schedulers: Schedulers
  let realmProvider: RealmProvider
  let buildConfig: BuildConfig

  private init() {
    let schedulers = DefaultSchedulers()

    let debug: Bool

    #if DEBUG
      debug = true
    #else
      debug = false
    #endif

    self.buildConfig = DefaultBuildConfig(debug: debug)

    var plugins = [PluginType]()

    if debug {
      plugins = [NetworkLoggerPlugin()]

      guard let docsDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
        Swift.fatalError("Can't find documents directory")
      }

      print("Documents directory: \(docsDir)")
    }

    let traktBuilder = TraktBuilder {
      $0.clientId = Secrets.Trakt.clientId
      $0.clientSecret = Secrets.Trakt.clientSecret
      $0.redirectURL = Secrets.Trakt.redirectURL
      $0.callbackQueue = schedulers.networkQueue
      $0.plugins = plugins
    }

    let tvdbBuilder = TVDBBuilder {
      $0.apiKey = Secrets.TVDB.apiKey
      $0.callbackQueue = schedulers.networkQueue
      $0.plugins = plugins
    }

    let trakt = Trakt(builder: traktBuilder)

    self.trakt = trakt
    self.tmdb = TMDB(apiKey: Secrets.TMDB.apiKey)
    self.tvdb = TVDB(builder: tvdbBuilder)

    self.schedulers = schedulers

    let traktLoginStore = TraktLoginStore(trakt: trakt)

    self.loginObservable = traktLoginStore
    self.defaultOutput = traktLoginStore.loginOutput

    self.realmProvider = DefaultRealmProvider(buildConfig: buildConfig)
  }
}
