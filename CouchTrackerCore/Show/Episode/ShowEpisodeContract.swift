import RxSwift
import TraktSwift

public protocol ShowEpisodeNetwork: AnyObject {
  func addToHistory(items: SyncItems) -> Single<SyncResponse>
  func removeFromHistory(items: SyncItems) -> Single<SyncResponse>
}

public protocol ShowEpisodeRepository: AnyObject {
  func addToHistory(episode: EpisodeEntity) -> Single<WatchedShowEntity>
  func removeFromHistory(episode: EpisodeEntity) -> Single<WatchedShowEntity>
}

public protocol ShowEpisodeInteractor: AnyObject {
  func fetchImages(for episode: EpisodeImageInput) -> Maybe<ShowEpisodeImages>
  func toggleWatch(for episode: WatchedEpisodeEntity) -> Single<WatchedShowEntity>
}

public protocol ShowEpisodePresenter: AnyObject {
  func viewDidLoad()
  func observeViewState() -> Observable<ShowEpisodeViewState>
  func handleWatch() -> Completable
}
