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
import Moya
import Moya_ObjectMapper
import RxTest
import RxSwift

final class ShowsTest: XCTestCase {
  private let showsProvider = RxMoyaProvider<Shows>(stubClosure: MoyaProvider.immediatelyStub)
  private let scheduler = TestScheduler(initialClock: 0)
  private var showObserver: TestableObserver<Show>!

  override func setUp() {
    super.setUp()

    showObserver = scheduler.createObserver(Show.self)
  }

  override func tearDown() {
    super.tearDown()

    showObserver = nil
  }

  func testShows_requestSummaryForAShow_parseToModels() {
    let target = Shows.summary(showId: "game-of-thrones", extended: .fullEpisodes)
    let disposable = showsProvider.request(target)
      .mapObject(Show.self)
      .subscribe(showObserver)

    scheduler.scheduleAt(500) {
      disposable.dispose()
    }

    scheduler.start()

    let expectedShow = try! Show(JSON: parseToJSONObject(data: target.sampleData))

    let expectedEvents: [Recorded<Event<Show>>] = [next(0, expectedShow), completed(0)]

    XCTAssertEqual(showObserver.events, expectedEvents)
  }

}
