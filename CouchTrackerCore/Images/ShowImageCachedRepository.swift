import Moya
import RxSwift
import TMDBSwift

public final class ShowImageCachedRepository: ShowImageRepository {
  private let configurationRepository: ConfigurationRepository
  private let tmdb: TMDBProvider
  private var cache = [Int: ImagesEntity]()

  public init(tmdb: TMDBProvider,
              configurationRepository: ConfigurationRepository) {
    self.configurationRepository = configurationRepository
    self.tmdb = tmdb
  }

  public func fetchShowImages(for showId: Int,
                              posterSize: PosterImageSize?,
                              backdropSize: BackdropImageSize?) -> Maybe<ImagesEntity> {
    let posterSize = posterSize ?? .w342
    let backdropSize = backdropSize ?? .w300

    let cacheKey = TMDBImageUtils.cacheKey(entityId: showId, posterSize: posterSize, backdropSize: backdropSize)

    guard let images = cache[cacheKey] else {
      return fetchImagesFromAPI(showId: showId, posterSize: posterSize, backdropSize: backdropSize)
        .asMaybe()
        .do(onNext: { [weak self] images in
          self?.cache[cacheKey] = images
        })
    }

    return Maybe.just(images)
  }

  private func fetchImagesFromAPI(showId: Int,
                                  posterSize: PosterImageSize,
                                  backdropSize: BackdropImageSize) -> Observable<ImagesEntity> {
    let target = Shows.images(showId: showId)
    let apiObservable = TMDBImageUtils.imagesFromAPI(using: tmdb.shows, with: target)
    return TMDBImageUtils.createImagesEntities(configurationRepository,
                                               apiObservable,
                                               posterSize: posterSize,
                                               backdropSize: backdropSize)
  }
}
