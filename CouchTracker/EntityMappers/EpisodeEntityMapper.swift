import TraktSwift

final class EpisodeEntityMapper {
	private init() {}

	static func entity(for episode: Episode, showIds: ShowIds) -> EpisodeEntity {
		return EpisodeEntity(ids: episode.ids,
	showIds: showIds,
	title: episode.title ?? "TBA".localized,
	overview: episode.overview,
	number: episode.number,
	season: episode.season,
	firstAired: episode.firstAired,
	lastWatched: nil)
	}
}
