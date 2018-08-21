import RxSwift
import TraktSwift

public final class WatchedSeasonsAssembler {
  private let seasonRepository: ShowSeasonsRepository
  private let schedulers: Schedulers
  private var cache = [Int: WatchedSeasonEntityBuilder]()

  public init(seasonRepository: ShowSeasonsRepository, schedulers: Schedulers) {
    self.seasonRepository = seasonRepository
    self.schedulers = schedulers
  }

  public func fetchWatchedSeasons(using builder: WatchedShowBuilder) -> Observable<WatchedShowBuilder> {
    return setSeasonsDetails(into: builder)
  }

  private func setSeasonsDetails(into builder: WatchedShowBuilder) -> Observable<WatchedShowBuilder> {
    guard let progressSeasons = builder.progressShow?.seasons else { Swift.fatalError("Seasons not present") }

    let builders = progressSeasons.map { (season) -> WatchedSeasonEntityBuilder in
      let seasonBuilder = WatchedSeasonEntityBuilder(showIds: builder.ids, special: false).set(progressSeason: season)
      cache[season.number] = seasonBuilder
      return seasonBuilder
    }

    return seasonRepository.fetchShowSeasons(showIds: builder.ids, extended: .fullEpisodes)
      .do(onSuccess: { [weak self] in
        guard let strongSelf = self else { return }
        WatchedSeasonsAssembler.setSeasonDetails(seasons: $0, cache: strongSelf.cache)
      }).asObservable()
      .map { _ in builder.set(seasons: builders) }
  }

  private static func setSeasonDetails(seasons: [Season], cache: [Int: WatchedSeasonEntityBuilder]) {
    seasons.forEach { season in
      if let builder = cache[season.number] {
        builder.set(detailSeason: season)
        WatchedSeasonsAssembler.setSeasonDetails(into: builder, using: season)
      } else {
        print("Season \(season.number) not found with id \(season.ids.trakt)")
      }
    }
  }

  private static func setSeasonDetails(into builder: WatchedSeasonEntityBuilder, using season: Season) {
    guard let episodes = season.episodes else { return }

    setEpisodes(into: builder, using: episodes, seasonIds: season.ids)
  }

  private static func setEpisodes(into builder: WatchedSeasonEntityBuilder,
                                  using episodes: [Episode], seasonIds _: SeasonIds) {
    let episodeBuilders = episodes.map { episode -> WatchedEpisodeEntityBuilder in
      let episodeBuilder = WatchedEpisodeEntityBuilder(showIds: builder.showIds, episode: episode)
      let watchedEpisode = builder.progressSeason?.episodes.first(where: { $0.number == episode.number })
      return episodeBuilder.set(lastWatched: watchedEpisode?.lastWatchedAt)
    }

    builder.set(episodes: episodeBuilders)
  }
}
