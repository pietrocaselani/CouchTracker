import ComposableArchitecture
import TraktSwift

struct TrendingMoviesState: Hashable {
    struct APIValues: Hashable {
        var page = 0
        var limit = 0
        var extended = Extended.full
    }

    var trendingMovies = [TrendingMovie]()
    var isRequestMoviesInFlight = false
    var genericError: TrendingMovieError?
    var apiValues = APIValues()
}

enum TrendingMoviesAction: Equatable {
    case requestNextPage
    case requestMoviesResponse(Result<[TrendingMovie], TrendingMovieError>)
}

struct TrendingMoviesEnvironment {
    var client: MoviesService
}

struct TrendingMovieError: Error, Hashable {
    let message: String
}

//let trendingMoviesReducer: Reducer<TrendingMoviesState, TrendingMoviesAction, TrendingMoviesEnvironment>
//trendingMoviesReducer = { state, action, environment in
//    switch action {
//    case .requestNextPage:
//        return requestMovies(&state, environment)
//    case let .requestMoviesResponse(result):
//        handleMoviesResponse(&state, result)
//        return .none
//    }
//}

private func requestMovies(
    _ state: inout TrendingMoviesState,
    _ environment: TrendingMoviesEnvironment
) -> Effect<TrendingMoviesAction, Never> {
    state.isRequestMoviesInFlight = true
    return environment.client.movies(
        .init(
            page: state.apiValues.page,
            limit: state.apiValues.limit,
            extended: state.apiValues.extended
        )
    )
    .mapError { (err: Error) -> TrendingMovieError in
        .init(message: err.localizedDescription)
    }
    .catchToEffect()
    .map(TrendingMoviesAction.requestMoviesResponse)
}

private func handleMoviesResponse(
    _ state: inout TrendingMoviesState,
    _ result: Result<[TrendingMovieEntity], TrendingMovieError>
) {
    state.isRequestMoviesInFlight = false
    switch result {
    case let .success(movies):
        state.apiValues.page += 1
        state.trendingMovies.append(contentsOf: movies)
    case let .failure(error):
        state.genericError = error
    }
}
