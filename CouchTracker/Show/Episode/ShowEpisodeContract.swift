import RxSwift
import TraktSwift

protocol ShowEpisodeRepository: class {
  func addToHistory(items: SyncItems) -> Single<SyncResponse>
  func removeFromHistory(items: SyncItems) -> Single<SyncResponse>
}

protocol ShowEpisodeInteractor: class {
  init(repository: ShowEpisodeRepository,
       showProgressInteractor: ShowProgressInteractor, imageRepository: ImageRepository)

  func fetchImageURL(for episode: EpisodeEntity) -> Single<URL>
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
