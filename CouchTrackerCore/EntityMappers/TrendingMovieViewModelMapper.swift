import TraktSwift

final class TrendingMovieViewModelMapper {
	private init() {
		Swift.fatalError("No instances for you!")
	}

	static func viewModel(for movie: MovieEntity, defaultTitle: String = "TBA".localized) -> TrendingViewModel {
		return TrendingViewModel(title: movie.title ?? defaultTitle, type: movie.ids.tmdbModelType())
	}

	static func viewModel(for movie: Movie, defaultTitle: String = "TBA".localized) -> TrendingViewModel {
		return TrendingViewModel(title: movie.title ?? defaultTitle, type: movie.ids.tmdbModelType())
	}
}
