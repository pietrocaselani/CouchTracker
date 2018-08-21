import Moya
import RxSwift
import TraktSwift

public final class ShowsProgressDefaultRepository: ShowsProgressRepository {
  private let assembler: WatchedShowsAssembler
  private let dataSource: ShowsProgressDataSource
  private let schedulers: Schedulers
  private let disposeBag = DisposeBag()

  public init(assembler: WatchedShowsAssembler, dataSource: ShowsProgressDataSource, schedulers: Schedulers) {
    self.assembler = assembler
    self.dataSource = dataSource
    self.schedulers = schedulers
  }

  public func fetchWatchedShowsProgress(extended: Extended, hiddingSpecials: Bool) -> Observable<[WatchedShowEntity]> {
    /*
     CT-TODO
     If API throws error, how to expose to DataSource observable?
     */
    updateShowsFromAPI(extended: extended, hiddingSpecials: hiddingSpecials)

    let assemblerObservable = updateShowsFromAssembler(extended: extended, hiddingSpecials: hiddingSpecials)

    let dataSourceObservable = fetchShowsFromDataSource()
      .ifEmpty(switchTo: assemblerObservable)
      .catchError { _ in assemblerObservable }

    return Observable.merge(dataSourceObservable, assemblerObservable)
  }

  public func reload(extended: Extended, hiddingSpecials: Bool) -> Completable {
    return updateShowsFromAssembler(extended: extended, hiddingSpecials: hiddingSpecials).ignoreElements()
  }

  private func fetchShowsFromDataSource() -> Observable<[WatchedShowEntity]> {
    return dataSource.fetchWatchedShows()
  }

  private func updateShowsFromAssembler(extended: Extended, hiddingSpecials: Bool) -> Observable<[WatchedShowEntity]> {
    let observable = assembler.fetchWatchedShows(extended: extended, hiddingSpecials: hiddingSpecials)

    return observable
      .toArray()
      .observeOn(schedulers.dataSourceScheduler)
      .do(onNext: { [weak self] entities in
        try self?.dataSource.addWatched(shows: entities)
      })
  }

  private func updateShowsFromAPI(extended: Extended, hiddingSpecials: Bool) {
    updateShowsFromAssembler(extended: extended, hiddingSpecials: hiddingSpecials)
      .ignoreElements()
      .subscribe()
      .disposed(by: disposeBag)
  }
}
