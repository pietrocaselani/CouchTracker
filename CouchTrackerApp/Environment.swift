import CouchTrackerCore
import Moya
import TMDBSwift
import TraktSwift
import TVDBSwift

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
  let appConfigurationsObservable: AppConfigurationsObservable
  let appConfigurationsOutput: AppConfigurationsOutput
  let showsSynchronizer: WatchedShowsSynchronizer
  let showSynchronizer: WatchedShowSynchronizer
  let watchedShowEntitiesObservable: WatchedShowEntitiesObservable
  let watchedShowEntityObserable: WatchedShowEntityObserable
  let centralSynchronizer: CentralSynchronizer
  let userDefaults: UserDefaults
  let genreRepository: GenreRepository
  let imageRepository: ImageRepository
  let configurationRepository: ConfigurationCachedRepository
  let movieImageRepository: MovieImageCachedRepository
  let showImageRepository: ShowImageCachedRepository
  let episodeImageRepository: EpisodeImageCachedRepository

  var currentAppState: AppConfigurationsState {
    return Environment.getAppState(userDefaults: userDefaults)
  }

  private static func getAppState(userDefaults: UserDefaults) -> AppConfigurationsState {
    let loginState = AppConfigurationsUserDefaultsDataSource.currentLoginValue(userDefaults)
    let hideSpecials = AppConfigurationsUserDefaultsDataSource.currentHideSpecialValue(userDefaults)
    return AppConfigurationsState(loginState: loginState, hideSpecials: hideSpecials)
  }

  // swiftlint:disable function_body_length
  private init() {
    userDefaults = UserDefaults.standard
    let schedulers = DefaultSchedulers.instance

    let debug: Bool

    let plugins = [PluginType]()

    #if DEBUG
      let traktClientId = Secrets.Trakt.clientId.isEmpty
      let tmdbAPIKey = Secrets.TMDB.apiKey.isEmpty
      let tvdbAPIKey = Secrets.TVDB.apiKey.isEmpty

      if traktClientId || tmdbAPIKey || tvdbAPIKey {
        Swift.fatalError("One or more API keys are empty. Check the class Secrets.swift")
      }

      debug = true
    #else
      debug = false
    #endif

    var traktPlugins = plugins
    // CT-TODO Remove this
    traktPlugins.append(NoCacheMoyaPlugin())

    buildConfig = DefaultBuildConfig(debug: debug)

    let traktBuilder = TraktBuilder {
      $0.clientId = Secrets.Trakt.clientId
      $0.clientSecret = Secrets.Trakt.clientSecret
      $0.redirectURL = Secrets.Trakt.redirectURL
      $0.callbackQueue = schedulers.networkQueue
      $0.plugins = traktPlugins
    }

    let tvdbBuilder = TVDBBuilder {
      $0.apiKey = Secrets.TVDB.apiKey
      $0.callbackQueue = schedulers.networkQueue
      $0.plugins = plugins
    }

    let trakt = Trakt(builder: traktBuilder)

    self.trakt = trakt
    tmdb = TMDB(apiKey: Secrets.TMDB.apiKey)
    tvdb = TVDB(builder: tvdbBuilder)

    self.schedulers = schedulers

    let traktLoginStore = TraktLoginStore(trakt: trakt)

    loginObservable = traktLoginStore
    defaultOutput = traktLoginStore.loginOutput

    realmProvider = DefaultRealmProvider(buildConfig: buildConfig)

    let appConfigurationsStore = AppConfigurationsStore(appState: Environment.getAppState(userDefaults: userDefaults))

    appConfigurationsOutput = appConfigurationsStore
    appConfigurationsObservable = appConfigurationsStore

    let genreDataSource = GenreRealmDataSource(realmProvider: realmProvider,
                                               schedulers: schedulers)

    genreRepository = TraktGenreRepository(traktProvider: trakt,
                                           dataSource: genreDataSource,
                                           schedulers: schedulers)

    let showsDownloader = DefaultWatchedShowEntitiesDownloader(trakt: trakt,
                                                               genreRepository: genreRepository,
                                                               scheduler: schedulers)

    let showDownloader = DefaultWatchedShowEntityDownloader(trakt: trakt,
                                                            scheduler: schedulers)

    let showDataSource = RealmShowDataSource(realmProvider: realmProvider, schedulers: schedulers)

    let showsDataSource = RealmShowsDataSource(realmProvider: realmProvider, schedulers: schedulers)

    watchedShowEntitiesObservable = showsDataSource
    watchedShowEntityObserable = showDataSource

    showsSynchronizer = DefaultWatchedShowsSynchronizer(downloader: showsDownloader,
                                                        dataHolder: showsDataSource,
                                                        schedulers: schedulers)

    showSynchronizer = DefaultWatchedShowSynchronizer(downloader: showDownloader,
                                                      dataSource: showDataSource,
                                                      scheduler: schedulers)

    centralSynchronizer = CentralSynchronizer.initialize(watchedShowsSynchronizer: showsSynchronizer,
                                                         appConfigObservable: appConfigurationsObservable)

    configurationRepository = ConfigurationCachedRepository(tmdbProvider: tmdb)

    movieImageRepository = MovieImageCachedRepository(tmdb: tmdb,
                                                      configurationRepository: configurationRepository)

    showImageRepository = ShowImageCachedRepository(tmdb: tmdb,
                                                    configurationRepository: configurationRepository)

    episodeImageRepository = EpisodeImageCachedRepository(tmdb: tmdb,
                                                          tvdb: tvdb,
                                                          configurationRepository: configurationRepository)

    imageRepository = ImageCachedRepository(movieImageRepository: movieImageRepository,
                                            showImageRepository: showImageRepository,
                                            episodeImageRepository: episodeImageRepository)
  }
}
