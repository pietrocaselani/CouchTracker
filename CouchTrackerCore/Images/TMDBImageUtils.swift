import Moya
import RxSwift
import TMDBSwift

enum TMDBImageUtils {
  static func createImagesEntities(_ configurationRepository: ConfigurationRepository,
                                   _ imagesObservable: Observable<Images>,
                                   posterSize: PosterImageSize? = nil,
                                   backdropSize: BackdropImageSize? = nil,
                                   stillSize: StillImageSize? = nil) -> Observable<ImagesEntity> {
    let configurationObservable = configurationRepository.fetchConfiguration()

    return Observable.combineLatest(imagesObservable, configurationObservable) {
      ImagesEntityMapper.entity(for: $0, using: $1,
                                posterSize: posterSize ?? .w342,
                                backdropSize: backdropSize ?? .w780,
                                stillSize: stillSize ?? .w300)
    }
  }

  static func cacheKey(entityId: Int,
                       posterSize: PosterImageSize,
                       backdropSize: BackdropImageSize) -> Int {
    var hasher = Hasher()
    hasher.combine(entityId)
    hasher.combine(posterSize)
    hasher.combine(backdropSize)
    return hasher.finalize()
  }

  static func imagesFromAPI<T: TMDBType>(using provider: MoyaProvider<T>, with target: T) -> Observable<Images> {
    provider.rx.request(target).filterSuccessfulStatusAndRedirectCodes().map(Images.self).asObservable()
  }
}
