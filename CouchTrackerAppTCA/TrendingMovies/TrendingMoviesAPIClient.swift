import ComposableArchitecture
import CouchTrackerCore
import TraktSwift

struct TrendingMoviesAPIClient {
    var movies: (TrendingMoviesRequest) -> Effect<[TrendingMovieEntity], Error>
}

struct TrendingMoviesRequest: Hashable {
    let page: Int
    let limit: Int
    let extended: Extended
}
