import TraktSwift

final class TrendingShowViewModelMapper {
	private init() {
		Swift.fatalError("No instances for you!")
	}

	static func viewModel(for show: ShowEntity, defaultTitle: String = "TBA".localized) -> TrendingViewModel {
		return TrendingViewModel(title: show.title ?? defaultTitle, type: show.ids.tmdbModelType())
	}

	static func viewModel(for show: Show, defaultTitle: String = "TBA".localized) -> TrendingViewModel {
		return TrendingViewModel(title: show.title ?? defaultTitle, type: show.ids.tmdbModelType())
	}
}
