import CouchTrackerCore
import CouchTrackerPersistence
import Moya
import TMDBSwift
import TraktSwift
import TVDBSwift

public struct AppEnvironment {
  public var trakt: TraktProvider = Environment.instance.trakt
  public var tmdb: TMDBProvider = Environment.instance.tmdb
  public var tvdb: TVDBProvider = Environment.instance.tvdb
  public var schedulers: Schedulers = Environment.instance.schedulers
  public var realmProvider: RealmProvider = Environment.instance.realmProvider
  public var buildConfig: BuildConfig = Environment.instance.buildConfig
  public var appStateManager: AppStateManager = Environment.instance.appStateManager
  public var showsSynchronizer: WatchedShowsSynchronizer = Environment.instance.showsSynchronizer
  public var showSynchronizer: WatchedShowSynchronizer = Environment.instance.showSynchronizer
  public var watchedShowEntitiesObservable: WatchedShowEntitiesObservable = Environment.instance.watchedShowEntitiesObservable
  public var watchedShowEntityObserable: WatchedShowEntityObserable = Environment.instance.watchedShowEntityObserable
  public var userDefaults: UserDefaults = Environment.instance.userDefaults
  public var genreRepository: GenreRepository = Environment.instance.genreRepository
  public var imageRepository: ImageRepository = Environment.instance.imageRepository
  public var configurationRepository: ConfigurationCachedRepository = Environment.instance.configurationRepository
  public var movieImageRepository: MovieImageCachedRepository = Environment.instance.movieImageRepository
  public var showImageRepository: ShowImageCachedRepository = Environment.instance.showImageRepository
  public var episodeImageRepository: EpisodeImageCachedRepository = Environment.instance.episodeImageRepository
  public var syncStateObservable: SyncStateObservable = Environment.instance.syncStateObservable
}
