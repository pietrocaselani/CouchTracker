import TraktSwift

public enum PosterShowViewModelMapper {
  public static func viewModel(for show: ShowEntity, defaultTitle: String = "TBA".localized) -> PosterViewModel {
    return PosterViewModel(title: show.title ?? defaultTitle, type: show.ids.tmdbModelType())
  }

  public static func viewModel(for show: Show, defaultTitle: String = "TBA".localized) -> PosterViewModel {
    return PosterViewModel(title: show.title ?? defaultTitle, type: show.ids.tmdbModelType())
  }
}
