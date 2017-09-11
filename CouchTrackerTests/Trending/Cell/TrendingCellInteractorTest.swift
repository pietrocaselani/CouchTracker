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

import XCTest
import RxTest
import RxSwift

final class TrendingCellInteractorTest: XCTestCase {

  let scheduler = TestScheduler(initialClock: 0)
  var observer: TestableObserver<URL>!

  override func setUp() {
    super.setUp()

    observer = scheduler.createObserver(URL.self)
  }

  func testTrendingInteractor_fetchPosterImageURLForShowSuccess_emitsOnCompleted() {
    let type = TrendingViewModelType.show(tmdbShowId: 2)
    let interactor = TrendingCellService(imageRepository: imageRepositoryRealMock)
    let observable = interactor.fetchPosterImageURL(of: type, with: PosterImageSize.w92)

    let disposable = observable.subscribe(observer)

    scheduler.scheduleAt(600) {
      disposable.dispose()
    }

    scheduler.start()

    let events: [Recorded<Event<URL>>] = [completed(0)]

    XCTAssertEqual(observer.events, events)
  }

  func testTrendingInteractor_fetchPosterImageURLForMovieFailure_emitsOnError() {
    let type = TrendingViewModelType.movie(tmdbMovieId: 4)
    let imageError = NSError(domain: "com.arctouch", code: 100, userInfo: nil)
    let interactor = TrendingCellService(imageRepository: ErrorImageRepositoryMock(error: imageError))
    let observable = interactor.fetchPosterImageURL(of: type, with: PosterImageSize.w92)

    let disposable = observable.subscribe(observer)

    scheduler.scheduleAt(600) {
      disposable.dispose()
    }

    scheduler.start()

    let events: [Recorded<Event<URL>>] = [error(0, imageError)]

    XCTAssertEqual(observer.events, events)
  }

  func testTrendingInteractor_fetchPosterImageURLForMovieSuccessReceivesEmptyData_emitsOnCompleted() {
    let type = TrendingViewModelType.movie(tmdbMovieId: 4)

    let images = [ImageEntity]()
    let imagesMock = ImagesEntity(identifier: 4, backdrops: images, posters: images)

    let repository = ImagesRepositorySampleMock(tmdbProvider: tmdbProviderMock,
                                                cofigurationRepository: configurationRepositoryMock, images: imagesMock)

    let interactor = TrendingCellService(imageRepository: repository)
    let observable = interactor.fetchPosterImageURL(of: type, with: PosterImageSize.w92)

    let disposable = observable.subscribe(observer)

    scheduler.scheduleAt(600) {
      disposable.dispose()
    }

    scheduler.start()

    let events: [Recorded<Event<URL>>] = [completed(0)]

    XCTAssertEqual(observer.events, events)
  }

  func testTrendingInteractor_fetchPosterImageURLForMovieSuccessReceivesData_emitsURL() {
    let type = TrendingViewModelType.movie(tmdbMovieId: 4)

    let image = ImageEntity(link: "https://pc.com", width: 123, height: 321, iso6391: nil, aspectRatio: 2.1, voteAverage: 3.2, voteCount: 5)
    let images = [image]
    let imagesMock = ImagesEntity(identifier: 4, backdrops: images, posters: images)

    let repository = ImagesRepositorySampleMock(tmdbProvider: tmdbProviderMock,
                                                cofigurationRepository: configurationRepositoryMock, images: imagesMock)

    let interactor = TrendingCellService(imageRepository: repository)
    let observable = interactor.fetchPosterImageURL(of: type, with: PosterImageSize.w92)

    let disposable = observable.subscribe(observer)

    scheduler.scheduleAt(600) {
      disposable.dispose()
    }

    scheduler.start()

    let events: [Recorded<Event<URL>>] = [next(0, URL(string: "https://pc.com")!), completed(0)]

    XCTAssertEqual(observer.events, events)
  }
}
