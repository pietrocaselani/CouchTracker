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

final class SearchInteractorTest: XCTestCase {
  private let scheduler = TestScheduler(initialClock: 0)
  private var observer: TestableObserver<[SearchResult]>!

  override func setUp() {
    super.setUp()

    observer = scheduler.createObserver([SearchResult].self)
  }

  override func tearDown() {
    observer = nil
    super.tearDown()
  }

  func testSearchInteractor_fetchSuccessEmptyData_andEmitsOnlyOnCompleted() {
    let interactor = SearchInteractor(store: EmptySearchStoreMock())

    let disposable = interactor.searchMovies(query: "Cool movie").subscribe(observer)

    scheduler.scheduleAt(500) { disposable.dispose() }

    let expectedEvents: [Recorded<Event<[SearchResult]>>] = [completed(0)]

    RXAssertEvents(observer, expectedEvents)
  }

  func testSearchInteractor_fetchSuccessReceivesData_andEmitDataAndOnCompleted() {
    let results = createSearchResultsMock()

    let interactor = SearchInteractor(store: SearchStoreMock(results: results))
    let disposable = interactor.searchMovies(query: "Tron").subscribe(observer)

    scheduler.scheduleAt(500) { disposable.dispose() }

    let expectedEvents: [Recorded<Event<[SearchResult]>>] = [next(0, results), completed(0)]

    RXAssertEvents(observer, expectedEvents)
  }
}
