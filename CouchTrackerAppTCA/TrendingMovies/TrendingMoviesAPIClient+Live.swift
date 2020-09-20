import ComposableArchitecture
import CouchTrackerCore
import TraktSwift
import Moya

import Combine

extension TrendingMoviesAPIClient {
    static func live(
        trakt: TraktProvider,
        genresClient: GenresAPIClient
    ) -> TrendingMoviesAPIClient {
        .init(
            movies: { (request: TrendingMoviesRequest) in
                let movies = requestTrendingMovies(trakt: trakt, request: request)
                let genres = genresClient.genres(.movies)

                return movies.zip(genres).map { trendingMovies, genres -> [TrendingMovieEntity] in
                    trendingMovies.map { movie -> TrendingMovieEntity in
                        MovieEntityMapper.entity(for: movie, with: genres)
                    }
                }.eraseToEffect()
            }
        )
    }
}

private func requestTrendingMovies(
    trakt: TraktProvider,
    request: TrendingMoviesRequest
) -> Effect<[TrendingMovie], Error> {
    trakt.movies.requestAsEffect(
        .trending(
            page: request.page,
            limit: request.limit,
            extended: request.extended
        )
    ).decoded(as: [TrendingMovie].self)
}
