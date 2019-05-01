import RxSwift
import TraktSwift

public protocol ShowOverviewRepository: AnyObject {
  func fetchDetailsOfShow(with identifier: String, extended: Extended) -> Single<Show>
}

public protocol ShowOverviewInteractor: AnyObject {
  init(showIds: ShowIds, repository: ShowOverviewRepository,
       genreRepository: GenreRepository, imageRepository: ImageRepository)

  func fetchDetailsOfShow() -> Single<ShowEntity>
  func fetchImages() -> Maybe<ImagesEntity>
}

public protocol ShowOverviewPresenter: AnyObject {
  init(interactor: ShowOverviewInteractor)

  func viewDidLoad()
  func observeViewState() -> Observable<ShowOverviewViewState>
  func observeImagesState() -> Observable<ShowOverviewImagesState>
}
