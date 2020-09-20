import ComposableArchitecture

struct Movie: Hashable {
    let title: String?
}

struct TrendingMoviesState {
    let movies: [Movie]
}
