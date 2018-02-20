import RxSwift

protocol TrendingCellView: class {
	var presenter: TrendingCellPresenter! { get set }

	func show(viewModel: TrendingCellViewModel)
	func showPosterImage(with url: URL)
}

protocol TrendingCellPresenter: class {
	init(view: TrendingCellView, interactor: TrendingCellInteractor, viewModel: TrendingViewModel)

	func viewWillAppear()
}

protocol TrendingCellInteractor: class {
	init(imageRepository: ImageRepository)

	func fetchPosterImageURL(of type: TrendingViewModelType, with size: PosterImageSize?) -> Observable<URL>
}
