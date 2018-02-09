import Foundation
import RxSwift

final class TrendingCellViewMock: TrendingCellView {
  var presenter: TrendingCellPresenter!
  var invokedShowPosterImage = false
  var invokedShowViewModel = false
  var invokedPosterImageParameters: (url: URL, Void)?
  var invokedShowViewModelParameters: (viewModel: TrendingCellViewModel, Void)?

  func showPosterImage(with url: URL) {
    invokedShowPosterImage = true
    invokedPosterImageParameters = (url, ())
  }

  func show(viewModel: TrendingCellViewModel) {
    invokedShowViewModel = true
    invokedShowViewModelParameters = (viewModel, ())
  }
}

final class TrendingCellInteractorMock: TrendingCellInteractor {
  private let imageRepository: ImageRepository

  init(imageRepository: ImageRepository) {
    self.imageRepository = imageRepository
  }

  func fetchPosterImageURL(of type: TrendingViewModelType, with size: PosterImageSize?) -> Observable<URL> {
    if case .movie(let tmdbId) = type {
      let observable = imageRepository.fetchMovieImages(for: tmdbId, posterSize: size, backdropSize: nil).asObservable()
      return observable.flatMap { imageEntity -> Observable<URL> in
        guard let imageLink = imageEntity.posterImage()?.link, let url = URL(string: imageLink) else {
          return Observable.empty()
        }

        return Observable.just(url)
      }
    }

    return Observable.empty()
  }
}
