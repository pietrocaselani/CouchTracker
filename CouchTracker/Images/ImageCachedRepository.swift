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
import TMDBSwift

final class ImageCachedRepository: ImageRepository {

  private let movieCache: BasicCache<Movies, Images>
  private let showCache: BasicCache<Shows, Images>
  private let configurationRepository: ConfigurationRepository

  init(tmdbProvider: TMDBProvider, cofigurationRepository: ConfigurationRepository) {
    self.configurationRepository = cofigurationRepository

    self.movieCache = MemoryCacheLevel<Movies, NSData>()
      .compose(DiskCacheLevel<Movies, NSData>())
      .compose(MoyaFetcher(provider: tmdbProvider.movies))
      .transformValues(JSONObjectTransfomer<Images>())

    self.showCache = MemoryCacheLevel<Shows, NSData>()
      .compose(DiskCacheLevel<Shows, NSData>())
      .compose(MoyaFetcher(provider: tmdbProvider.shows))
      .transformValues(JSONObjectTransfomer<Images>())
  }

  func fetchMovieImages(for movieId: Int, posterSize: PosterImageSize?,
                        backdropSize: BackdropImageSize?) -> Observable<ImagesEntity> {
    let imagesObservable = imagesForMovie(movieId)

    return createImagesEntities(imagesObservable, posterSize: posterSize, backdropSize: backdropSize).asObservable()
  }

  func fetchShowImages(for showId: Int, posterSize: PosterImageSize?,
                       backdropSize: BackdropImageSize?) -> Single<ImagesEntity> {
    let imagesObservable = imagesForShow(showId)
    return createImagesEntities(imagesObservable, posterSize: posterSize, backdropSize: backdropSize)
  }

  private func createImagesEntities(_ imagesObservable: Observable<Images>, posterSize: PosterImageSize?,
                                    backdropSize: BackdropImageSize?) -> Single<ImagesEntity> {
    let configurationObservable = configurationRepository.fetchConfiguration()

    let scheduler = SerialDispatchQueueScheduler(qos: .background)

    let observable = Observable.combineLatest(imagesObservable, configurationObservable) {
      return ImagesEntityMapper.entity(for: $0, using: $1,
                                       posterSize: posterSize ?? .w342, backdropSize: backdropSize ?? .w300)
    }

    return observable.subscribeOn(scheduler)
      .observeOn(scheduler)
      .asSingle()
  }

  private func imagesForMovie(_ movieId: Int) -> Observable<Images> {
    return movieCache.get(.images(movieId: movieId)).asObservable()
  }

  private func imagesForShow(_ showId: Int) -> Observable<Images> {
    return showCache.get(.images(showId: showId)).asObservable()
  }
}
