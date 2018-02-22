import RxSwift
import TraktSwift

public final class ShowDetailsService: ShowDetailsInteractor {
	private let showIds: ShowIds
	private let repository: ShowDetailsRepository
	private let genreRepository: GenreRepository
	private let imageRepository: ImageRepository

	public init(showIds: ShowIds, repository: ShowDetailsRepository,
													genreRepository: GenreRepository, imageRepository: ImageRepository) {
		self.showIds = showIds
		self.repository = repository
		self.genreRepository = genreRepository
		self.imageRepository = imageRepository
	}

	public func fetchDetailsOfShow() -> Single<ShowEntity> {
		let genreObservable = genreRepository.fetchShowsGenres()
		let showObservable = repository.fetchDetailsOfShow(with: showIds.slug, extended: .full).asObservable()

		return  Observable.combineLatest(showObservable, genreObservable) { (show, genres) -> ShowEntity in
			let showGenres = genres.filter { genre -> Bool in
				return show.genres?.contains(where: { $0 == genre.slug }) ?? false
			}

			return ShowEntityMapper.entity(for: show, with: showGenres)
		}.asSingle()
	}

	public func fetchImages() -> Single<ImagesEntity> {
		guard let tmdbId = showIds.tmdb else { return Single.just(ImagesEntity.empty()) }

		return imageRepository.fetchShowImages(for: tmdbId, posterSize: .w780, backdropSize: .w780)
	}
}
