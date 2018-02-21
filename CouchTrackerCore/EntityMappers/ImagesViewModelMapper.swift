final class ImagesViewModelMapper {
	private init() {}

	static func viewModel(for entity: ImagesEntity) -> ImagesViewModel {
		let posterLink = entity.posterImage()?.link
		let backdropLink = entity.backdropImage()?.link
		return ImagesViewModel(posterLink: posterLink, backdropLink: backdropLink)
	}
}
