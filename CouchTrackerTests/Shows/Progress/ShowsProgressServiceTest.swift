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
import RxSwift
import RxTest
import TraktSwift

final class ShowsProgressServiceTest: XCTestCase {
  private let repository = ShowsProgressMocks.ShowsProgressRepositoryMock(trakt: traktProviderMock, cache: AnyCache(CacheMock()))
  private let scheduler = TestScheduler(initialClock: 0)
  private var observer: TestableObserver<WatchedShowEntity>!

  override func setUp() {
    super.setUp()

    observer = scheduler.createObserver(WatchedShowEntity.self)
  }

  func testShowsProgressService_fetchWatchedProgress() {
    //Given
    let interactor = ShowsProgressService(repository: repository)

    //When
    _ = interactor.fetchWatchedShowsProgress(update: false).subscribe(observer)

    //Then
    let entity = ShowsProgressMocks.mockWatchedShowEntity()
    let expectedEvents = [next(0, entity), completed(0)]

    XCTAssertEqual(observer.events, expectedEvents)
  }
}
