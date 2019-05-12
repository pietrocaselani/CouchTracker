import TraktSwift

public enum EpisodeEntityMapper {
  public static func entity(for episode: Episode, showIds: ShowIds) -> EpisodeEntity {
    return EpisodeEntity(
      ids: episode.ids,
      showIds: showIds,
      title: episode.title ?? CouchTrackerCoreStrings.toBeAnnounced(), // CT-TODO Don't handle title here
      overview: episode.overview,
      number: episode.number,
      season: episode.season,
      firstAired: episode.firstAired,
      absoluteNumber: episode.absoluteNumber
    )
  }
}
