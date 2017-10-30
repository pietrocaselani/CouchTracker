import TraktSwift

final class MovieViewModelMapper {
  private init() {}

  static func viewModel(for movie: MovieEntity, defaultTitle: String = "TBA".localized) -> TrendingViewModel {
    return TrendingViewModel(title: movie.title ?? defaultTitle, type: movie.ids.tmdbModelType())
  }

  static func viewModel(for movie: Movie, defaultTitle: String = "TBA".localized) -> TrendingViewModel {
    return TrendingViewModel(title: movie.title ?? defaultTitle, type: movie.ids.tmdbModelType())
  }
}
