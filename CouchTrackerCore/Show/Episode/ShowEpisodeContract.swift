import RxSwift
import TraktSwift

public protocol ShowEpisodeDataSource: class {
    func updateWatched(show: WatchedShowEntity) throws
}

public protocol ShowEpisodeNetwork: class {
    func addToHistory(items: SyncItems) -> Single<SyncResponse>
    func removeFromHistory(items: SyncItems) -> Single<SyncResponse>
}

public protocol ShowEpisodeRepository: class {
    func addToHistory(of show: WatchedShowEntity, episode: EpisodeEntity) -> Single<SyncResult>
    func removeFromHistory(of show: WatchedShowEntity, episode: EpisodeEntity) -> Single<SyncResult>
}

public protocol ShowEpisodeInteractor: class {
    func fetchImageURL(for episode: EpisodeImageInput) -> Maybe<URL>
    func toggleWatch(for episode: EpisodeEntity, of show: WatchedShowEntity) -> Single<SyncResult>
}

public protocol ShowEpisodePresenter: class {
    init(interactor: ShowEpisodeInteractor, show: WatchedShowEntity)

    func viewDidLoad()
    func observeViewState() -> Observable<ShowEpisodeViewState>
    func observeImageState() -> Observable<ShowEpisodeImageState>
    func handleWatch() -> Maybe<SyncResult>
}

public protocol ShowEpisodeView: class {
    var presenter: ShowEpisodePresenter! { get set }
}
