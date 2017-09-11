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
    let interactor: ShowDetailsInteractor = ShowDetailsService(showId: "cool show", repository: showDetailsRepositoryMock, genreRepository: GenreRepositoryMock())
    XCTAssertNotNil(interactor)
  }

  func testShowDetailsInteractor_fetchDetailsFailure_emmitsError() {
    let showError = NSError(domain: "com.arctouch", code: 4)
    let repository = ShowDetailsRepositoryErrorMock(error: showError)
    let interactor = ShowDetailsService(showId: "cool show", repository: repository, genreRepository: GenreRepositoryMock())

    let errorExpectation = expectation(description: "Expect interactor to emit an error")

    let disposable = interactor.fetchDetailsOfShow().subscribe(onSuccess: { show in
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
    let interactor = ShowDetailsService(showId: "cool show", repository: showDetailsRepositoryMock, genreRepository: GenreRepositoryMock())

    let showExpectation = expectation(description: "Expect interactor to emit a show")

    let show = createTraktShowDetails()
    let showGenres = createShowsGenresMock().filter { genre -> Bool in
      show.genres?.contains(where: { $0 == genre.slug }) ?? false
    }
    let expectedEntity = ShowEntityMapper.entity(for: show, with: showGenres)

    let disposable = interactor.fetchDetailsOfShow().subscribe(onSuccess: { entity in
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
