import RxSwift
import TraktSwift

let showDetailsRepositoryMock = ShowDetailsRepositoryMock(traktProvider: traktProviderMock)

final class ShowDetailsRepositoryErrorMock: ShowDetailsRepository {
  private let error: Error

  init(traktProvider: TraktProvider = traktProviderMock) {
    self.error = NSError(domain: "com.arctouch", code: 120)
  }

  init(traktProvider: TraktProvider = traktProviderMock, error: Error) {
    self.error = error
  }

  func fetchDetailsOfShow(with identifier: String, extended: Extended) -> Single<Show> {
    return Single.error(error)
  }
}

final class ShowDetailsRepositoryMock: ShowDetailsRepository {
  private let provider: TraktProvider
  init(traktProvider: TraktProvider) {
    self.provider = traktProvider
  }

  func fetchDetailsOfShow(with identifier: String, extended: Extended) -> Single<Show> {
    return provider.shows.request(.summary(showId: identifier, extended: extended)).map(Show.self).asSingle()
  }
}

final class ShowDetailsInteractorMock: ShowDetailsInteractor {
  private let genreRepository: GenreRepository
  private let imageRepository: ImageRepository
  private let repository: ShowDetailsRepository
  private let showIds: ShowIds

  init(showIds: ShowIds, repository: ShowDetailsRepository,
       genreRepository: GenreRepository, imageRepository: ImageRepository) {
    self.showIds = showIds
    self.repository = repository
    self.genreRepository = genreRepository
    self.imageRepository = imageRepository
  }

  func fetchDetailsOfShow() -> Single<ShowEntity> {
    let genresObservable = genreRepository.fetchShowsGenres()
    let showObservable = repository.fetchDetailsOfShow(with: showIds.slug, extended: .full).asObservable()

    return Observable.combineLatest(showObservable, genresObservable, resultSelector: { (show, genres) -> ShowEntity in
      let showGenres = genres.filter { genre -> Bool in
        show.genres?.contains(where: { $0 == genre.slug }) ?? false
      }
      return ShowEntityMapper.entity(for: show, with: showGenres)
    }).asSingle()
  }

  func fetchImages() -> Single<ImagesEntity> {
    guard let tmdbId = showIds.tmdb else { return Single.never() }

    return imageRepository.fetchShowImages(for: tmdbId, posterSize: nil, backdropSize: nil)
  }
}

final class ShowDetailsRouterMock: ShowDetailsRouter {
  var invokedShowError = false
  var invokedShowErrorParameters: (message: String, Void)?

  func showError(message: String) {
    invokedShowError = true
    invokedShowErrorParameters = (message, ())
  }
}

final class ShowDetailsViewMock: ShowDetailsView {
  var presenter: ShowDetailsPresenter!
  var invokedShowDetails = false
  var invokedShowDetailsParameters: (details: ShowDetailsViewModel, Void)?
  var invokedShowImages = false
  var invokedShowImagesParameters: (images: ImagesViewModel, Void)?

  func show(details: ShowDetailsViewModel) {
    invokedShowDetails = true
    invokedShowDetailsParameters = (details, ())
  }

  func show(images: ImagesViewModel) {
    invokedShowImages = true
    invokedShowImagesParameters = (images, ())
  }
}

func createTraktShowDetails() -> Show {
  let json = JSONParser.toObject(data: Shows.summary(showId: "game-of-thrones", extended: .full).sampleData)
  return try! Show(JSON: json)
}
