import RxSwift
import TraktSwift

public protocol ShowOverviewRepository: class {
  func fetchDetailsOfShow(with identifier: String, extended: Extended) -> Single<Show>
}

public protocol ShowOverviewInteractor: class {
  init(showIds: ShowIds, repository: ShowOverviewRepository,
       genreRepository: GenreRepository, imageRepository: ImageRepository)

  func fetchDetailsOfShow() -> Single<ShowEntity>
  func fetchImages() -> Maybe<ImagesEntity>
}

public protocol ShowOverviewPresenter: class {
  init(interactor: ShowOverviewInteractor)

  func viewDidLoad()
  func observeViewState() -> Observable<ShowOverviewViewState>
  func observeImagesState() -> Observable<ShowOverviewImagesState>
}

public protocol ShowOverviewView: class {
  var presenter: ShowOverviewPresenter! { get set }
}
