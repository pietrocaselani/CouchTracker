import RxSwift

public enum ShowProgressCellViewState: Hashable {
  case viewModel(viewModel: WatchedShowViewModel)
  case viewModelAndPosterURL(viewModel: WatchedShowViewModel, url: URL)
}

public protocol ShowProgressCellPresenter: class {
  init(interactor: ShowProgressCellInteractor, viewModel: WatchedShowViewModel)

  func viewWillAppear()
  func observeViewState() -> Observable<ShowProgressCellViewState>
}

public protocol ShowProgressCellInteractor: class {
  init(imageRepository: ImageRepository)

  func fetchPosterImageURL(for tmdbId: Int, with size: PosterImageSize?) -> Maybe<URL>
}
