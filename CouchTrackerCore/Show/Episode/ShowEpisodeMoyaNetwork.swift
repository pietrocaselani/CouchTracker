import Moya
import RxSwift
import TraktSwift

public final class ShowEpisodeMoyaNetwork: ShowEpisodeNetwork {
  private let trakt: TraktProvider
  private let schedulers: Schedulers

  public init(trakt: TraktProvider, schedulers: Schedulers = DefaultSchedulers.instance) {
    self.trakt = trakt
    self.schedulers = schedulers
  }

  public func addToHistory(items: SyncItems) -> Single<SyncResponse> {
    let target = Sync.addToHistory(items: items)
    return performRequest(target)
  }

  public func removeFromHistory(items: SyncItems) -> Single<SyncResponse> {
    let target = Sync.removeFromHistory(items: items)
    return performRequest(target)
  }

  private func performRequest(_ target: Sync) -> Single<SyncResponse> {
    trakt.sync.rx.request(target)
      .observeOn(schedulers.networkScheduler)
      .filterSuccessfulStatusAndRedirectCodes()
      .map(SyncResponse.self)
  }
}
