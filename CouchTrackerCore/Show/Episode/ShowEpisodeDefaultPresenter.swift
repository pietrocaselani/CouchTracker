import RxSwift

public final class ShowEpisodeDefaultPresenter: ShowEpisodePresenter {
  private var show: WatchedShowEntity
  private let interactor: ShowEpisodeInteractor
  private let viewStateSubject = BehaviorSubject<ShowEpisodeViewState>(value: ShowEpisodeViewState.loading)
  private let imageStateSubject = BehaviorSubject<ShowEpisodeImageState>(value: ShowEpisodeImageState.loading)
  private let disposeBag = DisposeBag()

  public init(interactor: ShowEpisodeInteractor, show: WatchedShowEntity) {
    self.interactor = interactor
    self.show = show
  }

  public func viewDidLoad() {
    setupView()
  }

  public func observeViewState() -> Observable<ShowEpisodeViewState> {
    return viewStateSubject.distinctUntilChanged()
  }

  public func observeImageState() -> Observable<ShowEpisodeImageState> {
    return imageStateSubject.distinctUntilChanged()
  }

  public func handleWatch() -> Maybe<SyncResult> {
    guard let nextEpisode = show.nextEpisode else { return Maybe.empty() }

    return interactor.toggleWatch(for: nextEpisode, of: show)
      .do(onSuccess: { [weak self] syncResult in
        if case let .success(newShow) = syncResult {
          self?.show = newShow
          self?.setupView()
        }
      }).asMaybe()
  }

  private func setupView() {
    guard let nextEpisode = show.nextEpisode else {
      viewStateSubject.onNext(.empty)
      imageStateSubject.onNext(.none)
      return
    }

    interactor.fetchImageURL(for: nextEpisode)
      .map { ShowEpisodeImageState.image(url: $0) }
      .ifEmpty(default: ShowEpisodeImageState.none)
      .catchError { Single.just(ShowEpisodeImageState.error(error: $0)) }
      .do(onSubscribe: { [weak self] in
        self?.imageStateSubject.onNext(.loading)
      })
      .observeOn(MainScheduler.instance)
      .subscribe(onSuccess: { [weak self] imageState in
        self?.imageStateSubject.onNext(imageState)
      }).disposed(by: disposeBag)

    viewStateSubject.onNext(.showing(episode: nextEpisode))
  }
}
