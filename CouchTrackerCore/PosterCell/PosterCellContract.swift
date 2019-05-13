import RxSwift

public protocol PosterCellView: AnyObject {
  // swiftlint:disable implicitly_unwrapped_optional
  var presenter: PosterCellPresenter! { get set }
  // swiftlint:enable implicitly_unwrapped_optional

  func show(viewModel: PosterCellViewModel)
  func showPosterImage(with url: URL)
}

public protocol PosterCellPresenter: AnyObject {
  init(view: PosterCellView, interactor: PosterCellInteractor, viewModel: PosterViewModel)

  func viewWillAppear()
}

public protocol PosterCellInteractor: AnyObject {
  init(imageRepository: ImageRepository)

  func fetchPosterImageURL(of type: PosterViewModelType, with size: PosterImageSize?) -> Maybe<URL>
}
