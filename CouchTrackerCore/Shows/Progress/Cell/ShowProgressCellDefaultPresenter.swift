import RxSwift

public final class ShowProgressCellDefaultPresenter: ShowProgressCellPresenter {
  private let viewStateSubject: BehaviorSubject<ShowProgressCellViewState>
  private let interactor: ShowProgressCellInteractor
  private let viewModel: WatchedShowViewModel
  private let disposeBag = DisposeBag()

  public init(interactor: ShowProgressCellInteractor, viewModel: WatchedShowViewModel) {
    self.interactor = interactor
    self.viewModel = viewModel
    viewStateSubject = BehaviorSubject(value: .viewModel(viewModel: viewModel))
  }

  public func observeViewState() -> Observable<ShowProgressCellViewState> {
    return viewStateSubject.distinctUntilChanged()
  }

  public func viewWillAppear() {
    guard let tmdbId = viewModel.tmdbId else { return }

    guard let viewState = try? viewStateSubject.value(),
      case let .viewModel(model) = viewState else {
      return
    }

    interactor.fetchPosterImageURL(for: tmdbId, with: .w185)
      .map { ShowProgressCellViewState.viewModelAndPosterURL(viewModel: model, url: $0) }
      .catchErrorJustReturn(.viewModel(viewModel: model))
      .ifEmpty(default: .viewModel(viewModel: model))
      .observeOn(MainScheduler.instance)
      .subscribe(onSuccess: { [weak self] newViewState in
        self?.viewStateSubject.onNext(newViewState)
      }).disposed(by: disposeBag)
  }
}
