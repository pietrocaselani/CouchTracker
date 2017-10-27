import RxSwift
import Trakt

protocol ShowDetailsRepository: class {
  init(traktProvider: TraktProvider)

  func fetchDetailsOfShow(with identifier: String, extended: Extended) -> Single<Show>
}

protocol ShowDetailsInteractor: class {
  init(showIds: ShowIds, repository: ShowDetailsRepository,
       genreRepository: GenreRepository, imageRepository: ImageRepository)

  func fetchDetailsOfShow() -> Single<ShowEntity>
  func fetchImages() -> Single<ImagesEntity>
}

protocol ShowDetailsPresenter: class {
  init(view: ShowDetailsView, router: ShowDetailsRouter, interactor: ShowDetailsInteractor)

  func viewDidLoad()
}

protocol ShowDetailsRouter: class {
  func showError(message: String)
}

protocol ShowDetailsView: class {
  var presenter: ShowDetailsPresenter! { get set }

  func show(details: ShowDetailsViewModel)
  func show(images: ImagesViewModel)
}
