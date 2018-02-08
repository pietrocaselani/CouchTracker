import RxSwift
import TraktSwift

protocol ShowEpisodeDataSource: class {
  func updateWatched(show: WatchedShowEntity) throws
}

protocol ShowEpisodeRepository: class {
  func addToHistory(of show: WatchedShowEntity, episode: EpisodeEntity) -> Single<SyncResult>
  func removeFromHistory(of show: WatchedShowEntity, episode: EpisodeEntity) -> Single<SyncResult>
}

protocol ShowEpisodeInteractor: class {
  func fetchImageURL(for episode: EpisodeImageInput) -> Single<URL>
  func toggleWatch(for episode: EpisodeEntity, of show: WatchedShowEntity) -> Single<SyncResult>
}

protocol ShowEpisodePresenter: class {
  init(view: ShowEpisodeView, interactor: ShowEpisodeInteractor, show: WatchedShowEntity)

  func viewDidLoad()
  func handleWatch()
}

protocol ShowEpisodeView: class {
  var presenter: ShowEpisodePresenter! { get set }

  func showEmptyView()
  func showEpisodeImage(with url: URL)
  func show(viewModel: ShowEpisodeViewModel)
}
