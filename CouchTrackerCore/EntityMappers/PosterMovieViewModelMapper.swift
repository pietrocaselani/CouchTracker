import TraktSwift

public final class PosterMovieViewModelMapper {
    private init() {
        Swift.fatalError("No instances for you!")
    }

    public static func viewModel(for movie: MovieEntity, defaultTitle: String = "TBA".localized) -> PosterViewModel {
        return PosterViewModel(title: movie.title ?? defaultTitle, type: movie.ids.tmdbModelType())
    }

    public static func viewModel(for movie: Movie, defaultTitle: String = "TBA".localized) -> PosterViewModel {
        return PosterViewModel(title: movie.title ?? defaultTitle, type: movie.ids.tmdbModelType())
    }
}
