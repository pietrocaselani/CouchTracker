import RxSwift
import TraktSwift

public final class ShowsProgressService: ShowsProgressInteractor {
  private let repository: ShowsProgressRepository
  private let listStateDataSource: ShowsProgressListStateDataSource
  private let schedulers: Schedulers
  private var hideSpecials: Bool
  private let disposeBag = DisposeBag()

  public var listState: ShowProgressListState {
    get {
      return listStateDataSource.currentState
    }
    set {
      listStateDataSource.currentState = newValue
    }
  }

  public init(repository: ShowsProgressRepository,
              listStateDataSource: ShowsProgressListStateDataSource,
              appConfigurationsObservable: AppConfigurationsObservable,
              schedulers: Schedulers,
              hideSpecials: Bool) {
    self.repository = repository
    self.listStateDataSource = listStateDataSource
    self.schedulers = schedulers
    self.hideSpecials = hideSpecials

    appConfigurationsObservable.observe()
      .flatMap { [weak self] newState -> Observable<Never> in
        guard let strongSelf = self else { return Observable.empty() }

        strongSelf.hideSpecials = newState.hideSpecials
        return strongSelf.repository.reload(extended: .fullEpisodes, hiddingSpecials: newState.hideSpecials)
          .asObservable()
      }.subscribe()
      .disposed(by: disposeBag)
  }

  public func fetchWatchedShowsProgress() -> Observable<[WatchedShowEntity]> {
    let observable = repository.fetchWatchedShowsProgress(extended: .fullEpisodes, hiddingSpecials: hideSpecials)
    return observable.distinctUntilChanged()
  }
}
