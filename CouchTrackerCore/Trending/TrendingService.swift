import Moya
import RxSwift
import TMDBSwift
import TraktSwift

public final class TrendingService: TrendingInteractor {
  private let repository: TrendingRepository
  private let genreRepository: GenreRepository

  public init(repository: TrendingRepository, genreRepository: GenreRepository) {
    self.repository = repository
    self.genreRepository = genreRepository
  }

  public func fetchShows(page: Int, limit: Int) -> Single<[TrendingShowEntity]> {
    repository.fetchShows(page: page, limit: limit)
      .flatMap { [weak self] shows in
        guard let strongSelf = self else { return Single.just([TrendingShowEntity]()) }
        return strongSelf.mapTrendingShows(shows)
      }
  }

  public func fetchMovies(page: Int, limit: Int) -> Single<[TrendingMovieEntity]> {
    repository.fetchMovies(page: page, limit: limit)
      .flatMap { [weak self] movies in
        guard let strongSelf = self else { return Single.just([TrendingMovieEntity]()) }
        return strongSelf.mapTrendingMovies(movies)
      }
  }

  private func mapTrendingShows(_ trendingShows: [TrendingShow]) -> Single<[TrendingShowEntity]> {
    genreRepository.fetchShowsGenres().map { genres in
      trendingShows.map { ShowEntityMapper.entity(for: $0, with: $0.show.genres(for: genres)) }
    }
  }

  private func mapTrendingMovies(_ trendingMovies: [TrendingMovie]) -> Single<[TrendingMovieEntity]> {
    genreRepository.fetchShowsGenres().map { genres in
      trendingMovies.map { MovieEntityMapper.entity(for: $0, with: $0.movie.genres(for: genres)) }
    }
  }
}
