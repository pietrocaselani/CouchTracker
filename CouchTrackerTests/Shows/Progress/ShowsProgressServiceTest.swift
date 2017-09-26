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
    let ids = ShowIds(trakt: 46263, tmdb: 46533, imdb: "tt2149175", slug: "the-americans-2013", tvdb: 261690, tvrage: 30449)
    let show = ShowEntity(ids: ids,
                          title: "The Americans",
                          overview: "The Americans is a period drama about the complex marriage of two KGB spies posing as Americans in suburban Washington D.C. shortly after Ronald Reagan is elected President. The arranged marriage of Philip and Elizabeth Jennings, who have two children - 13-year-old Paige and 10-year-old Henry, who know nothing about their parents' true identity - grows more passionate and genuine by the day, but is constantly tested by the escalation of the Cold War and the intimate, dangerous and darkly funny relationships they must maintain with a network of spies and informants under their control.",
                          network: "FX (US)",
                          genres: nil,
                          status: Status.returning,
                          firstAired: TraktDateTransformer.dateTimeTransformer.transformFromJSON("2013-01-30T00:00:00.000Z"))
    let episodeIds = EpisodeIds(trakt: 73640, tmdb: 63056, imdb: "tt1480055", tvdb: 3254641, tvrage: 1065008299)
    let nextEpisode = EpisodeEntity(ids: episodeIds, title: "Winter Is Coming", number: 1, season: 1, firstAired: TraktDateTransformer.dateTimeTransformer.transformFromJSON("2011-04-18T01:00:00.000Z"))
    let entity = WatchedShowEntity(show: show, aired: 65, completed: 60, nextEpisode: nextEpisode)

    let expectedEvents = [next(0, entity), completed(0)]

    XCTAssertEqual(observer.events, expectedEvents)
  }
}
