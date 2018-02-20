import RxSwift

protocol ShowProgressCellView: class {
	var presenter: ShowProgressCellPresenter! { get set }

	func show(viewModel: WatchedShowViewModel)
	func showPosterImage(with url: URL)
}

protocol ShowProgressCellPresenter: class {
	init(view: ShowProgressCellView, interactor: ShowProgressCellInteractor, viewModel: WatchedShowViewModel)

	func viewWillAppear()
}

protocol ShowProgressCellInteractor: class {
	init(imageRepository: ImageRepository)

	func fetchPosterImageURL(for tmdbId: Int, with size: PosterImageSize?) -> Observable<URL>
}
