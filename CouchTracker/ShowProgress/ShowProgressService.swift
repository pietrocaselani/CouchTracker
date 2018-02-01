import RxSwift
import TraktSwift

//TODO Inject AppConfigurations to handle hidden and specials episodes
final class ShowProgressService: ShowProgressInteractor {
  private let repository: ShowProgressRepository
  
  init(repository: ShowProgressRepository) {
    self.repository = repository
  }
  
  func fetchShowProgress(ids: ShowIds) -> Observable<WatchedShowBuilder> {
    let builder = WatchedShowBuilder(ids: ids)
    
    return fetchProgressForShow(builder)
      .flatMap { [unowned self] in self.fetchNextEpisodeDetails($0) }
  }
  
  private func fetchProgressForShow(_ builder: WatchedShowBuilder) -> Observable<WatchedShowBuilder> {
    let showId = builder.ids.realId
    
    let observable = repository.fetchShowProgress(showId: showId,
                                                  hidden: false, specials: false, countSpecials: false)
    
    return observable.map {
      builder.detailShow = $0
      return builder
    }
  }
  
  private func fetchNextEpisodeDetails(_ builder: WatchedShowBuilder) -> Observable<WatchedShowBuilder> {
    guard let episode = builder.detailShow?.nextEpisode else { return Observable.just(builder) }
    
    let showId = builder.ids.realId
    
    let observable = repository.fetchDetailsOf(episodeNumber: episode.number,
                                               on: episode.season, of: showId, extended: .full)
    
    return observable.map {
      builder.episode = $0
      return builder
      }.catchErrorJustReturn(builder)
  }
}
