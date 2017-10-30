import RxSwift
import TraktSwift

final class ShowProgressService: ShowProgressInteractor {
  private let repository: ShowProgressRepository

  init(repository: ShowProgressRepository) {
    self.repository = repository
  }

  func fetchShowProgress(update: Bool, ids: ShowIds) -> Observable<WatchedShowBuilder> {
    let builder = WatchedShowBuilder(ids: ids)

    return fetchProgressForShow(update: update, builder)
      .flatMap { [unowned self] in self.fetchNextEpisodeDetails(update: update, $0) }
  }

  private func fetchProgressForShow(update: Bool, _ builder: WatchedShowBuilder) -> Observable<WatchedShowBuilder> {
    let showId = builder.ids.realId

    let observable = repository.fetchShowProgress(update: update, showId: showId,
                                                  hidden: false, specials: false, countSpecials: false)

    return observable.map {
      builder.detailShow = $0
      return builder
    }
  }

  private func fetchNextEpisodeDetails(update: Bool, _ builder: WatchedShowBuilder) -> Observable<WatchedShowBuilder> {
    guard let episode = builder.detailShow?.nextEpisode else { return Observable.just(builder) }

    let showId = builder.ids.realId

    let observable = repository.fetchDetailsOf(update: update, episodeNumber: episode.number,
                                               on: episode.season, of: showId, extended: .full)

    return observable.map {
      builder.episode = $0
      return builder
    }
  }
}
