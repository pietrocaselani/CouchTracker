import RxSwift

public protocol PosterCellView: class {
    var presenter: PosterCellPresenter! { get set }

    func show(viewModel: PosterCellViewModel)
    func showPosterImage(with url: URL)
}

public protocol PosterCellPresenter: class {
    init(view: PosterCellView, interactor: PosterCellInteractor, viewModel: PosterViewModel)

    func viewWillAppear()
}

public protocol PosterCellInteractor: class {
    init(imageRepository: ImageRepository)

    func fetchPosterImageURL(of type: PosterViewModelType, with size: PosterImageSize?) -> Maybe<URL>
}
