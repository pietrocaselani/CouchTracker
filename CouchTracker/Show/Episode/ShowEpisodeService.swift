import RxSwift
import TraktSwift

final class ShowEpisodeService: ShowEpisodeInteractor {
	private let repository: ShowEpisodeRepository
	private let imageRepository: ImageRepository

	init(repository: ShowEpisodeRepository, imageRepository: ImageRepository) {
		self.repository = repository
		self.imageRepository = imageRepository
	}

	func fetchImageURL(for episode: EpisodeImageInput) -> Single<URL> {
		let size = EpisodeImageSizes(tvdb: .normal, tmdb: .w300)
		return imageRepository.fetchEpisodeImages(for: episode, size: size)
	}

	func toggleWatch(for episode: EpisodeEntity, of show: WatchedShowEntity) -> Single<SyncResult> {
		return episode.lastWatched == nil ?
			repository.addToHistory(of: show, episode: episode) : repository.removeFromHistory(of: show, episode: episode)
	}
}
