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

final class MovieImageCachedRepository: MovieImageRepository {

  private let cache: BasicCache<Movies, Images>
  private let configurationRepository: ConfigurationRepository

  init(tmdbProvider: TMDBProvider, cofigurationRepository: ConfigurationRepository) {
    self.configurationRepository = cofigurationRepository

    self.cache = MemoryCacheLevel<Movies, NSData>()
      .compose(DiskCacheLevel<Movies, NSData>())
      .compose(MoyaFetcher(provider: tmdbProvider.movies))
      .transformValues(JSONObjectTransfomer<Images>())
  }

  func fetchImages(for movieId: Int, posterSize: PosterImageSize?, backdropSize: BackdropImageSize?) -> Observable<ImagesEntity> {
    let configurationObservable = configurationRepository.fetchConfiguration()
    let imagesObservable = images(for: movieId)

    let observable = Observable.combineLatest(imagesObservable, configurationObservable) {
      return entity(for: $0, using: $1, posterSize: posterSize ?? .w342, backdropSize: backdropSize ?? .w300)
    }

    return observable
  }

  private func images(for movieId: Int) -> Observable<Images> {
    let scheduler = SerialDispatchQueueScheduler(qos: .background)
    return cache.get(.images(movieId: movieId)).asObservable().subscribeOn(scheduler).observeOn(scheduler)
  }
}
