import RxSwift
import TraktSwift

public final class WatchedSeasonsAssembler {
  private let seasonRepository: ShowSeasonsRepository
  private let schedulers: Schedulers

  public init(seasonRepository: ShowSeasonsRepository, schedulers: Schedulers) {
    self.seasonRepository = seasonRepository
    self.schedulers = schedulers
  }

  public func fetchWatchedSeasons(using builder: WatchedShowBuilder) -> Observable<WatchedShowBuilder> {
    return setSeasonsDetails(into: builder)
  }

  private func setSeasonsDetails(into builder: WatchedShowBuilder) -> Observable<WatchedShowBuilder> {
    guard let progressSeasons = builder.progressShow?.seasons else { Swift.fatalError("Seasons not present") }

    let builders = progressSeasons.map {
      return WatchedSeasonEntityBuilder(showIds: builder.ids, special: false).set(progressSeason: $0)
    }

    return seasonRepository.fetchShowSeasons(showIds: builder.ids, extended: .fullEpisodes)
      .asObservable()
      .flatMap { Observable.from($0) }
      .do(onNext: { WatchedSeasonsAssembler.setSeasonDetails(into: builders, using: $0) })
      .map { _ in builder.set(seasons: builders) }
  }

  private static func setSeasonDetails(into builders: [WatchedSeasonEntityBuilder], using season: Season) {
    let b = builders.first { $0.progressSeason?.number ?? -1 == season.number }

    guard let builder = b else {
      print("Season \(season.number) not found")
      return
    }

    builder.set(detailSeason: season)

    guard let episodes = season.episodes else { return }

    setEpisodes(into: builder, using: episodes, seasonIds: season.ids)
  }

  private static func setEpisodes(into builder: WatchedSeasonEntityBuilder, using episodes: [Episode], seasonIds _: SeasonIds) {
    let episodeBuilders = episodes.map { episode -> WatchedEpisodeEntityBuilder in
      let episodeBuilder = WatchedEpisodeEntityBuilder(showIds: builder.showIds, episode: episode)
      let watchedEpisode = builder.progressSeason?.episodes.first(where: { $0.number == episode.number })
      return episodeBuilder.set(lastWatched: watchedEpisode?.lastWatchedAt)
    }

    builder.set(episodes: episodeBuilders)
  }
}
