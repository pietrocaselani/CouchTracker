/*
 Copyright 2017 ArcTouch LLC.
 All rights reserved.
 
 This file, its contents, concepts, methods, behavior, and operation
 (collectively the "Software") are protected by trade secret, patent,
 and copyright laws. The use of the Software is governed by a license
 agreement. Disclosure of the Software to third parties, in any form,
 in whole or in part, is expressly prohibited except as authorized by
 the license agreement.
 */

import Carlos
import Moya
import RxSwift
import TMDB_Swift

final class ImageCachedRepository: ImageRepository {

  private let cache: BasicCache<String, Images>
  private let showsProvider: RxMoyaProvider<Shows>
  private let moviesProvider: RxMoyaProvider<Movies>
  private let configurationRepository: ConfigurationRepository

  init(tmdbProvider: TMDBProvider, cofigurationRepository: ConfigurationRepository) {
    self.configurationRepository = cofigurationRepository
    self.showsProvider = tmdbProvider.shows
    self.moviesProvider = tmdbProvider.movies

    self.cache = MemoryCacheLevel<String, NSData>()
      .compose(DiskCacheLevel<String, NSData>())
      .transformValues(JSONObjectTransfomer<Images>())
  }

  func fetchMovieImages(for movieId: Int, posterSize: PosterImageSize?,
                        backdropSize: BackdropImageSize?) -> Observable<ImagesEntity> {
    let target = Movies.images(movieId: movieId)

    let cacheObservable = imagesFromCache(with: target.toString())
    let apiObservable = imagesFromAPI(using: moviesProvider, with: target)
    let imagesObservable = cacheObservable.ifEmpty(switchTo: apiObservable)

    return createImagesEntities(imagesObservable, posterSize: posterSize, backdropSize: backdropSize)
  }

  func fetchShowImages(for showId: Int, posterSize: PosterImageSize?,
                       backdropSize: BackdropImageSize?) -> Single<ImagesEntity> {
    let target = Shows.images(showId: showId)

    let cacheObservable = imagesFromCache(with: target.toString())
    let apiObservable = imagesFromAPI(using: showsProvider, with: target)
    let imagesObservable = cacheObservable.ifEmpty(switchTo: apiObservable)

    return createImagesEntities(imagesObservable, posterSize: posterSize, backdropSize: backdropSize).asSingle()
  }

  private func createImagesEntities(_ imagesObservable: Observable<Images>, posterSize: PosterImageSize?,
                                    backdropSize: BackdropImageSize?) -> Observable<ImagesEntity> {
    let configurationObservable = configurationRepository.fetchConfiguration()

    let observable = Observable.combineLatest(imagesObservable, configurationObservable) {
      return ImagesEntityMapper.entity(for: $0, using: $1,
                                       posterSize: posterSize ?? .w342, backdropSize: backdropSize ?? .w300)
      }

    let scheduler = SerialDispatchQueueScheduler(qos: .background)

    return observable.subscribeOn(scheduler).observeOn(scheduler)
  }

  private func imagesFromCache(with key: String) -> Observable<Images> {
    return cache.get(key).asObservable()
  }

  private func imagesFromAPI<T: TMDBType & StringConvertible>(using provider: RxMoyaProvider<T>,
                                                              with target: T) -> Observable<Images> {
    return provider.request(target).mapObject(Images.self).do(onNext: { [unowned self] images in
      _ = self.cache.set(images, forKey: target.toString())
    })
  }
}
