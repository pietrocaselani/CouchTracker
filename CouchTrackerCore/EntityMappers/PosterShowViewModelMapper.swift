import TraktSwift

public enum PosterShowViewModelMapper {
  public static func viewModel(for show: ShowEntity,
                               defaultTitle: String = CouchTrackerCoreStrings.toBeAnnounced()) -> PosterViewModel {
    return PosterViewModel(title: show.title ?? defaultTitle, type: show.ids.tmdbModelType())
  }

  public static func viewModel(for show: Show,
                               defaultTitle: String = CouchTrackerCoreStrings.toBeAnnounced()) -> PosterViewModel {
    return PosterViewModel(title: show.title ?? defaultTitle, type: show.ids.tmdbModelType())
  }
}
