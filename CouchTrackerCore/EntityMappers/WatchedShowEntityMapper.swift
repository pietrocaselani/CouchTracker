public final class WatchedShowEntityMapper {
    private init() {
        Swift.fatalError("No instances for you!")
    }

    public static func viewModel(for entity: WatchedShowEntity) -> WatchedShowViewModel {
        let nextEpisodeTitle = entity.nextEpisode.map { "\($0.season)x\($0.number) \($0.title)" }
        let nextEpisodeDateText = nextEpisodeDate(for: entity)
        let statusText = status(for: entity)

        return WatchedShowViewModel(title: entity.show.title ?? "TBA".localized,
                                    nextEpisode: nextEpisodeTitle,
                                    nextEpisodeDate: nextEpisodeDateText,
                                    status: statusText,
                                    tmdbId: entity.show.ids.tmdb)
    }

    public static func status(for entity: WatchedShowEntity) -> String {
        let episodesRemaining = entity.aired - entity.completed
        var status = episodesRemaining == 0 ? "" : "episodes remaining".localized(String(episodesRemaining))

        if let network = entity.show.network {
            status = episodesRemaining == 0 ? network : "\(status) \(network)"
        }

        return status
    }

    public static func nextEpisodeDate(for entity: WatchedShowEntity) -> String {
        if let nextEpisodeDate = entity.nextEpisode?.firstAired?.shortString() {
            return nextEpisodeDate
        }

        if let showStatus = entity.show.status?.rawValue.localized {
            return showStatus
        }

        return "Unknown".localized
    }
}
