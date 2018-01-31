import TraktSwift
import RxSwift

final class ShowEpisodeAPIRepository: ShowEpisodeRepository {
  private let trakt: TraktProvider
  private let schedulers: Schedulers

  init(trakt: TraktProvider, schedulers: Schedulers) {
    self.trakt = trakt
    self.schedulers = schedulers
  }

  func addToHistory(items: SyncItems) -> Single<SyncResponse> {
    return trakt.sync.rx.request(.addToHistory(items: items))
      .observeOn(schedulers.networkScheduler)
      .filterSuccessfulStatusAndRedirectCodes()
      .map(SyncResponse.self)
  }

  func removeFromHistory(items: SyncItems) -> Single<SyncResponse> {
    return trakt.sync.rx.request(.removeFromHistory(items: items))
      .observeOn(schedulers.networkScheduler)
      .filterSuccessfulStatusAndRedirectCodes()
      .map(SyncResponse.self)
  }
}
