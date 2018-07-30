import RxSwift
import TraktSwift

public final class ShowEpisodeService: ShowEpisodeInteractor {
    private let repository: ShowEpisodeRepository
    private let imageRepository: ImageRepository

    public init(repository: ShowEpisodeRepository, imageRepository: ImageRepository) {
        self.repository = repository
        self.imageRepository = imageRepository
    }

    public func fetchImageURL(for episode: EpisodeImageInput) -> Maybe<URL> {
        let size = EpisodeImageSizes(tvdb: .normal, tmdb: .w300)
        return imageRepository.fetchEpisodeImages(for: episode, size: size)
    }

    public func toggleWatch(for episode: EpisodeEntity, of show: WatchedShowEntity) -> Single<SyncResult> {
        return episode.lastWatched == nil ?
            repository.addToHistory(of: show, episode: episode) : repository.removeFromHistory(of: show, episode: episode)
    }
}
