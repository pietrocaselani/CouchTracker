import RxSwift
import TraktSwift

public final class WatchedSeasonsAssembler {
  private let seasonRepository: ShowSeasonsRepository
  private let schedulers: Schedulers

  public init(seasonRepository: ShowSeasonsRepository, schedulers: Schedulers) {
    self.seasonRepository = seasonRepository
    self.schedulers = schedulers
  }

  public func fetchWatchedSeasons(using ids: ShowIds) -> Single<[WatchedSeasonEntityBuilder]> {
    return setSeasonsDetails(ids: ids)
  }

  private func setSeasonsDetails(ids: ShowIds) -> Single<[WatchedSeasonEntityBuilder]> {
    return seasonRepository.fetchShowSeasons(showIds: ids, extended: .fullEpisodes)
      .map { seasons -> [WatchedSeasonEntityBuilder] in
        seasons.map {
          let builder = WatchedSeasonEntityBuilder(showIds: ids).set(detailSeason: $0)
          return WatchedSeasonsAssembler.setSeasonEpisodes(into: builder, using: $0)
        }
      }
  }

  private static func setSeasonEpisodes(into builder: WatchedSeasonEntityBuilder,
                                        using season: Season) -> WatchedSeasonEntityBuilder {
    guard let episodes = season.episodes else { return builder }

    return setEpisodes(into: builder, using: episodes, seasonIds: season.ids)
  }

  private static func setEpisodes(into builder: WatchedSeasonEntityBuilder,
                                  using episodes: [Episode], seasonIds _: SeasonIds) -> WatchedSeasonEntityBuilder {
    let episodeBuilders = episodes.map { episode -> WatchedEpisodeEntityBuilder in
      let episodeBuilder = WatchedEpisodeEntityBuilder(showIds: builder.showIds, episode: episode)
      let watchedEpisode = builder.progressSeason?.episodes.first(where: { $0.number == episode.number })
      return episodeBuilder.set(lastWatched: watchedEpisode?.lastWatchedAt)
    }

    return builder.set(episodes: episodeBuilders)
  }
}
