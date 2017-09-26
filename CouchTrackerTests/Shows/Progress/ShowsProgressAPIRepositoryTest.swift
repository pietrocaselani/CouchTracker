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

final class ShowsProgressAPIRepositoryTest: XCTestCase {
  private let cache = CacheMock()
  private let trakt = TraktProviderMock()
  private let scheduler = TestScheduler(initialClock: 0)
  private let disposeBag = CompositeDisposable()

  override func tearDown() {
    cache.entries.removeAll()
    disposeBag.dispose()
    super.tearDown()
  }

  func testShowsProgressRepository_fetchesShowsWithEmptyCache_hitOnAPISavesOnCache() {
    //Given
    let repository = ShowsProgressAPIRepository(trakt: trakt, cache: AnyCache(cache), scheduler: scheduler)
    let observer = scheduler.createObserver([BaseShow].self)

    //When
    _ = repository.fetchWatchedShows(update: false, extended: .full).subscribe(observer)
    scheduler.start()

    //Then
    let expectedShows = ShowsProgressMocks.createWatchedShowsMock()
    let expectedEvents = [next(0, expectedShows), completed(0)]

    RXAssertEvents(observer, expectedEvents)
    XCTAssertFalse(cache.entries.isEmpty)
    XCTAssertTrue(cache.getInvoked)
    XCTAssertTrue(cache.setInvoked)
  }

  func testShowsProgressRepository_fetchesShowProgressWithEmptyCache_hitOnAPISavesOnCache() {
    //Given
    let repository = ShowsProgressAPIRepository(trakt: trakt, cache: AnyCache(cache), scheduler: scheduler)
    let observer = scheduler.createObserver(BaseShow.self)
    let showId = "the-americans-2013"

    //When
    _ = repository.fetchShowProgress(update: false, showId: showId, hidden: false, specials: false, countSpecials: false).subscribe(observer)
    scheduler.start()

    //Then
    let expectedShow = ShowsProgressMocks.createShowMock(showId)!
    let expectedEvents = [next(3, expectedShow), completed(4)]

    XCTAssertEqual(observer.events, expectedEvents)
    XCTAssertFalse(cache.entries.isEmpty)
    XCTAssertTrue(cache.getInvoked)
    XCTAssertTrue(cache.setInvoked)
  }

  func testShowsProgressRepository_fetchesEpisodeWithEmptyCache_hitOnAPISavesOnCache() {
    //Given
    let repository = ShowsProgressAPIRepository(trakt: trakt, cache: AnyCache(cache), scheduler: scheduler)
    let observer = scheduler.createObserver(Episode.self)
    let showId = "game-of-thrones"

    //When
    _ = repository.fetchDetailsOf(update: false, episodeNumber: 1, on: 1, of: showId, extended: .full).subscribe(observer)
    scheduler.start()

    //Then
    let expectedEpisode = ShowsProgressMocks.createEpisodeMock(showId)
    let expectedEvents = [next(3, expectedEpisode), completed(4)]

    XCTAssertEqual(observer.events, expectedEvents)
    XCTAssertFalse(cache.entries.isEmpty)
    XCTAssertTrue(cache.getInvoked)
    XCTAssertTrue(cache.setInvoked)
  }

  func testShowsProgressRepository_fetchesShowsForcingUpdate_cantHitOnCache() {
    //Given
    let repository = ShowsProgressAPIRepository(trakt: trakt, cache: AnyCache(cache), scheduler: scheduler)
    let observer = scheduler.createObserver([BaseShow].self)

    //When
    _ = repository.fetchWatchedShows(update: true, extended: .full).subscribe(observer)
    scheduler.start()

    //Then
    let expectedShows = ShowsProgressMocks.createWatchedShowsMock()
    let expectedEvents = [next(0, expectedShows), completed(0)]

    RXAssertEvents(observer, expectedEvents)
    XCTAssertFalse(cache.entries.isEmpty)
    XCTAssertFalse(cache.getInvoked)
    XCTAssertTrue(cache.setInvoked)
  }

  func testShowsProgressRepository_fetchesShowsFromCache_cantHitOnAPI() {
    //Given
    let target = Sync.watched(type: .shows, extended: .full)
    let entriesCache = CacheMock(entries: [target.hashValue: target.sampleData as NSData])
    let repository = ShowsProgressAPIRepository(trakt: trakt, cache: AnyCache(entriesCache), scheduler: scheduler)
    let observer = scheduler.createObserver([BaseShow].self)

    //When
    _ = repository.fetchWatchedShows(update: false, extended: .full).subscribe(observer)
    scheduler.start()

    //Then
    let expectedShows = ShowsProgressMocks.createWatchedShowsMock()
    let expectedEvents = [next(0, expectedShows), completed(0)]

    RXAssertEvents(observer, expectedEvents)
    XCTAssertTrue(entriesCache.getInvoked)
    XCTAssertFalse(entriesCache.setInvoked)
  }
}
