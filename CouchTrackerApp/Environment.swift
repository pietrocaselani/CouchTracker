import CouchTrackerCore
import CouchTrackerPersistence
import Moya
import TMDBSwift
import TraktSwift
import TVDBSwift

public final class Environment {
  public static let instance = Environment()
  public let trakt: TraktProvider
  public let tmdb: TMDBProvider
  public let tvdb: TVDBProvider
  public let schedulers: Schedulers
  public let realmProvider: RealmProvider
  public let buildConfig: BuildConfig
  public let appStateManager: AppStateManager
  public let showsSynchronizer: WatchedShowsSynchronizer
  public let showSynchronizer: WatchedShowSynchronizer
  public let watchedShowEntitiesObservable: WatchedShowEntitiesObservable
  public let watchedShowEntityObserable: WatchedShowEntityObserable
  public let userDefaults: UserDefaults
  public let genreRepository: GenreRepository
  public let imageRepository: ImageRepository
  public let configurationRepository: ConfigurationCachedRepository
  public let movieImageRepository: MovieImageCachedRepository
  public let showImageRepository: ShowImageCachedRepository
  public let episodeImageRepository: EpisodeImageCachedRepository
  public let syncStateObservable: SyncStateObservable

  var currentAppState: AppState {
    return Environment.getAppState(userDefaults: userDefaults)
  }

  private static func getAppState(userDefaults: UserDefaults) -> AppState {
    return UserDefaultsAppStateDataHolder.currentAppConfig(userDefaults)
  }

  // swiftlint:disable function_body_length
  private init() {
    userDefaults = UserDefaults.standard
    let schedulers = DefaultSchedulers.instance

    DefaultBundleProvider.update(userDefaults: userDefaults)

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

    realmProvider = DefaultRealmProvider(buildConfig: buildConfig)

    let appStateDataHolder = UserDefaultsAppStateDataHolder(userDefaults: userDefaults)
    let appState = Environment.getAppState(userDefaults: userDefaults)

    appStateManager = DefaultAppStateManager(appState: appState, trakt: trakt, dataHolder: appStateDataHolder)

    let genreDataSource = GenreRealmDataSource(realmProvider: realmProvider,
                                               scheduler: schedulers.dataSourceScheduler)

    genreRepository = TraktGenreRepository(traktProvider: trakt,
                                           dataSource: genreDataSource,
                                           schedulers: schedulers)

    let showsDownloader = DefaultWatchedShowEntitiesDownloader(trakt: trakt,
                                                               genreRepository: genreRepository,
                                                               scheduler: schedulers)

    let showDownloader = DefaultWatchedShowEntityDownloader(trakt: trakt,
                                                            scheduler: schedulers)

    let showDataSource = RealmShowDataSource(realmProvider: realmProvider, scheduler: schedulers.dataSourceScheduler)

    let showsDataSource = RealmShowsDataSource(realmProvider: realmProvider,
                                               scheduler: schedulers.dataSourceScheduler)

    let showsSynchronizer = DefaultWatchedShowsSynchronizer(downloader: showsDownloader,
                                                            dataHolder: showsDataSource,
                                                            schedulers: schedulers)

    let showSynchronizer = DefaultWatchedShowSynchronizer(downloader: showDownloader,
                                                          dataSource: showDataSource,
                                                          scheduler: schedulers)

    let centralSynchronizer = CentralSynchronizer(watchedShowsSynchronizer: showsSynchronizer,
                                                  watchedShowSynchronizer: showSynchronizer,
                                                  appStateObservable: appStateManager)

    self.showsSynchronizer = centralSynchronizer
    self.showSynchronizer = centralSynchronizer
    syncStateObservable = centralSynchronizer

    watchedShowEntitiesObservable = showsDataSource
    watchedShowEntityObserable = showDataSource

    configurationRepository = ConfigurationCachedRepository(tmdbProvider: tmdb)

    movieImageRepository = MovieImageCachedRepository(tmdb: tmdb,
                                                      configurationRepository: configurationRepository)

    showImageRepository = ShowImageCachedRepository(tmdb: tmdb,
                                                    configurationRepository: configurationRepository)

    episodeImageRepository = EpisodeImageCachedRepository(tmdb: tmdb,
                                                          tvdb: tvdb,
                                                          configurationRepository: configurationRepository)

    imageRepository = DefaultImageRepository(movieImageRepository: movieImageRepository,
                                             showImageRepository: showImageRepository,
                                             episodeImageRepository: episodeImageRepository)
  }
}
