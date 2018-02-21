import RxSwift
import Moya
import TraktSwift
import TMDBSwift

public final class TrendingService: TrendingInteractor {
	private let repository: TrendingRepository
	private let imageRepository: ImageRepository

	public init(repository: TrendingRepository, imageRepository: ImageRepository) {
		self.repository = repository
		self.imageRepository = imageRepository
	}

	public func fetchShows(page: Int, limit: Int) -> Observable<[TrendingShowEntity]> {
		return repository.fetchShows(page: page, limit: limit)
			.map { [unowned self] in self.mapTrendingShowsToEntities($0) }
	}

	public func fetchMovies(page: Int, limit: Int) -> Observable<[TrendingMovieEntity]> {
		return repository.fetchMovies(page: page, limit: limit)
			.map { [unowned self] in self.mapTrendingMoviesToEntities($0) }
	}

	private func mapTrendingShowsToEntities(_ trendingShows: [TrendingShow]) -> [TrendingShowEntity] {
		return trendingShows.map { ShowEntityMapper.entity(for: $0) }
	}

	private func mapTrendingMoviesToEntities(_ trendingMovies: [TrendingMovie]) -> [TrendingMovieEntity] {
		return trendingMovies.map { MovieEntityMapper.entity(for: $0) }
	}
}
