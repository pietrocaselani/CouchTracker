import Moya
import RxSwift
import TMDBSwift

public final class MovieImageCachedRepository: MovieImageRepository {
  private let configurationRepository: ConfigurationRepository
  private let tmdb: TMDBProvider
  private var cache = [Int: ImagesEntity]()

  public init(tmdb: TMDBProvider,
              configurationRepository: ConfigurationRepository) {
    self.configurationRepository = configurationRepository
    self.tmdb = tmdb
  }

  public func fetchMovieImages(for movieId: Int,
                               posterSize: PosterImageSize?,
                               backdropSize: BackdropImageSize?) -> Maybe<ImagesEntity> {
    let posterSize = posterSize ?? .w342
    let backdropSize = backdropSize ?? .w300

    let cacheKey = TMDBImageUtils.cacheKey(entityId: movieId, posterSize: posterSize, backdropSize: backdropSize)

    guard let images = cache[cacheKey] else {
      return fetchImagesFromAPI(movieId: movieId, posterSize: posterSize, backdropSize: backdropSize)
        .asMaybe()
        .do(onNext: { [weak self] imagesEntity in
          self?.cache[cacheKey] = imagesEntity
        })
    }

    return Maybe.just(images)
  }

  private func fetchImagesFromAPI(movieId: Int,
                                  posterSize: PosterImageSize,
                                  backdropSize: BackdropImageSize) -> Observable<ImagesEntity> {
    let target = Movies.images(movieId: movieId)
    let apiObservable = TMDBImageUtils.imagesFromAPI(using: tmdb.movies, with: target)
    return TMDBImageUtils.createImagesEntities(configurationRepository,
                                               apiObservable,
                                               posterSize: posterSize,
                                               backdropSize: backdropSize)
  }
}
