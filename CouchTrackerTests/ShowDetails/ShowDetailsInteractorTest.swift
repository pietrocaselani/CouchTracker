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
import ObjectMapper
import Trakt_Swift

final class ShowDetailsInteractorTest: XCTestCase {

  private let scheduler = TestScheduler(initialClock: 0)

  func testCanCreateShowDetailsInteractor() {
    let interactor: ShowDetailsInteractor = ShowDetailsService(repository: showDetailsRepositoryMock)
    XCTAssertNotNil(interactor)
  }

  func testShowDetailsInteractor_fetchDetailsFailure_emmitsError() {
    let showError = NSError(domain: "com.arctouch", code: 4)
    let repository = ShowDetailsRepositoryErrorMock(error: showError)
    let interactor = ShowDetailsService(repository: repository)

    let errorExpectation = expectation(description: "Expect interactor to emit an error")

    let disposable = interactor.fetchDetailsOfShow(with: "cool show").subscribe(onSuccess: { show in
      XCTFail()
    }) { error in
      XCTAssertEqual(error as NSError, showError)
      errorExpectation.fulfill()
    }

    scheduler.scheduleAt(600) {
      disposable.dispose()
    }

    scheduler.start()

    wait(for: [errorExpectation], timeout: 1)
  }

  func testShowDetailsInteractor_fetchDetailsSuccess_emmitsShow() {
    let interactor = ShowDetailsService(repository: showDetailsRepositoryMock)

    let showExpectation = expectation(description: "Expect interactor to emit a show")

    let showId = "game-of-thrones"

    let json = parseToJSONObject(data: Shows.summary(showId: showId, extended: .full).sampleData)
    let show = try! Show(JSON: json)
    let expectedEntity = ShowEntityMapper.entity(for: show)

    let disposable = interactor.fetchDetailsOfShow(with: showId).subscribe(onSuccess: { entity in
      XCTAssertEqual(entity, expectedEntity)
      showExpectation.fulfill()
    }) { _ in
      XCTFail()
    }

    scheduler.scheduleAt(600) {
      disposable.dispose()
    }

    wait(for: [showExpectation], timeout: 1)
  }
}
