import RxSwift

final class TrendingCellService: TrendingCellInteractor {
  private let imageRepository: ImageRepository

  init(imageRepository: ImageRepository) {
    self.imageRepository = imageRepository
  }

  func fetchPosterImageURL(of type: TrendingViewModelType, with size: PosterImageSize?) -> Observable<URL> {
    let imagesObservable: Single<ImagesEntity>

    switch type {
    case .movie(let tmdbMovieId):
      imagesObservable = imageRepository.fetchMovieImages(for: tmdbMovieId, posterSize: size, backdropSize: nil)
    case .show(let tmdbShowId):
      let single = imageRepository.fetchShowImages(for: tmdbShowId, posterSize: size, backdropSize: nil)
      imagesObservable = single
    }

    return imagesObservable.asObservable().flatMap { images -> Observable<URL> in
      guard let imageLink = images.posterImage()?.link,
        let imageURL = URL(string: imageLink) else {
          return Observable.empty()
      }

      return Observable.just(imageURL)
    }
  }
}
