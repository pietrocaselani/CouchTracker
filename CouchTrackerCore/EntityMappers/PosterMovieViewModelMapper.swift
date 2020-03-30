import TraktSwift

public enum PosterMovieViewModelMapper {
  private typealias Strings = CouchTrackerCoreStrings

  public static func viewModel(for movie: MovieEntity,
                               defaultTitle: String = CouchTrackerCoreStrings.toBeAnnounced()) -> PosterViewModel {
    PosterViewModel(title: movie.title ?? defaultTitle, type: movie.ids.tmdbModelType())
  }

  public static func viewModel(for movie: Movie,
                               defaultTitle: String = CouchTrackerCoreStrings.toBeAnnounced()) -> PosterViewModel {
    PosterViewModel(title: movie.title ?? defaultTitle, type: movie.ids.tmdbModelType())
  }
}
