import RxSwift

public final class ShowEpisodeDefaultPresenter: ShowEpisodePresenter {
  private let schedulers: Schedulers
  private let interactor: ShowEpisodeInteractor
  private let viewStateSubject = BehaviorSubject<ShowEpisodeViewState>(value: ShowEpisodeViewState.empty)
  private let disposeBag = DisposeBag()

  public init(interactor: ShowEpisodeInteractor,
              show: WatchedShowEntity,
              schedulers: Schedulers = DefaultSchedulers.instance) {
    self.interactor = interactor
    self.schedulers = schedulers
    setupView(episode: show.nextEpisode)
  }

  public func viewDidLoad() {}

  public func observeViewState() -> Observable<ShowEpisodeViewState> {
    return viewStateSubject.distinctUntilChanged()
  }

  public func handleWatch() -> Completable {
    guard let episode = (try? viewStateSubject.value())?.episode else { return Completable.empty() }

    return interactor.toggleWatch(for: episode)
      .observeOn(schedulers.mainScheduler)
      .do(onSuccess: { [weak self] newShow in
        self?.setupView(episode: newShow.nextEpisode)
      }).asCompletable()
  }

  private func setupView(episode: WatchedEpisodeEntity?) {
    guard let nextEpisode = episode else {
      viewStateSubject.onNext(.empty)
      return
    }

    interactor.fetchImages(for: nextEpisode.asImageInput())
      .map { ShowEpisodeViewState.showing(episode: nextEpisode, images: $0) }
      .ifEmpty(default: ShowEpisodeViewState.showingEpisode(episode: nextEpisode))
      .catchError { _ in Single.just(ShowEpisodeViewState.showingEpisode(episode: nextEpisode)) }
      .observeOn(schedulers.mainScheduler)
      .do(onSubscribe: { [weak self] in
        self?.viewStateSubject.onNext(.loading)
      })
      .subscribe(onSuccess: { [weak self] viewState in
        self?.viewStateSubject.onNext(viewState)
      }).disposed(by: disposeBag)
  }
}
