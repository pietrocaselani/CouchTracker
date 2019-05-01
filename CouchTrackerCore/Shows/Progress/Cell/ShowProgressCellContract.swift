import RxSwift

public enum ShowProgressCellViewState: Hashable {
  case viewModel(viewModel: WatchedShowViewModel)
  case viewModelAndPosterURL(viewModel: WatchedShowViewModel, url: URL)
}

public protocol ShowProgressCellPresenter: AnyObject {
  init(interactor: ShowProgressCellInteractor, viewModel: WatchedShowViewModel)

  func viewWillAppear()
  func observeViewState() -> Observable<ShowProgressCellViewState>
}

public protocol ShowProgressCellInteractor: AnyObject {
  init(imageRepository: ImageRepository)

  func fetchPosterImageURL(for tmdbId: Int, with size: PosterImageSize?) -> Maybe<URL>
}
