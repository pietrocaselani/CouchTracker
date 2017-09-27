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

import TraktSwift
import RxSwift

final class ShowsProgressMocks {
  private init() {}

  static func createWatchedShowsMock() -> [BaseShow] {
    let array = JSONParser.toArray(data: Sync.watched(type: .shows, extended: .full).sampleData)
    return array.map { try! BaseShow(JSON: $0) }
  }

  static func createShowMock(_ showId: String) -> BaseShow? {
    let json = JSONParser.toObject(data: Shows.watchedProgress(showId: showId, hidden: false, specials: false, countSpecials: false).sampleData)
    return BaseShow(JSON: json)
  }

  static func createEpisodeMock(_ showId: String) -> Episode {
    let json = JSONParser.toObject(data: Episodes.summary(showId: showId, season: 1, episode: 1, extended: .full).sampleData)
    return try! Episode(JSON: json)
  }

  static func mockWatchedShowEntity() -> WatchedShowEntity {
    let dateTransformer = TraktDateTransformer.dateTimeTransformer

    let ids = ShowIds(trakt: 46263, tmdb: 46533, imdb: "tt2149175", slug: "the-americans-2013", tvdb: 261690, tvrage: 30449)
    let show = ShowEntity(ids: ids,
                          title: "The Americans",
                          overview: "The Americans is a period drama about the complex marriage of two KGB spies posing as Americans in suburban Washington D.C. shortly after Ronald Reagan is elected President. The arranged marriage of Philip and Elizabeth Jennings, who have two children - 13-year-old Paige and 10-year-old Henry, who know nothing about their parents' true identity - grows more passionate and genuine by the day, but is constantly tested by the escalation of the Cold War and the intimate, dangerous and darkly funny relationships they must maintain with a network of spies and informants under their control.",
                          network: "FX (US)",
                          genres: nil,
                          status: Status.returning,
                          firstAired: dateTransformer.transformFromJSON("2013-01-30T00:00:00.000Z"))
    let episodeIds = EpisodeIds(trakt: 73640, tmdb: 63056, imdb: "tt1480055", tvdb: 3254641, tvrage: 1065008299)
    let nextEpisode = EpisodeEntity(ids: episodeIds, title: "Winter Is Coming", number: 1, season: 1, firstAired: dateTransformer.transformFromJSON("2011-04-18T01:00:00.000Z"))
    return WatchedShowEntity(show: show, aired: 65, completed: 60, nextEpisode: nextEpisode)
  }

  static func mockWatchedShowEntityWithoutNextEpisode() -> WatchedShowEntity {
    let dateTransformer = TraktDateTransformer.dateTimeTransformer

    let ids = ShowIds(trakt: 46263, tmdb: 46533, imdb: "tt2149175", slug: "the-americans-2013", tvdb: 261690, tvrage: 30449)
    let show = ShowEntity(ids: ids,
                          title: "The Americans 2",
                          overview: "The Americans is a period drama about the complex marriage of two KGB spies posing as Americans.",
                          network: "FX (US)",
                          genres: nil,
                          status: Status.returning,
                          firstAired: dateTransformer.transformFromJSON("2013-01-30T00:00:00.000Z"))
    return WatchedShowEntity(show: show, aired: 65, completed: 65, nextEpisode: nil)
  }

  static func mockWatchedShowEntityWithoutNextEpisodeDate() -> WatchedShowEntity {
    let dateTransformer = TraktDateTransformer.dateTimeTransformer

    let ids = ShowIds(trakt: 46263, tmdb: 46533, imdb: "tt2149175", slug: "the-americans-2013", tvdb: 261690, tvrage: 30449)
    let show = ShowEntity(ids: ids,
                          title: "The Americans",
                          overview: "The Americans is a period drama about...",
                          network: "FX (US)",
                          genres: nil,
                          status: Status.returning,
                          firstAired: dateTransformer.transformFromJSON("2013-01-30T00:00:00.000Z"))
    let episodeIds = EpisodeIds(trakt: 73640, tmdb: 63056, imdb: "tt1480055", tvdb: 3254641, tvrage: 1065008299)
    let nextEpisode = EpisodeEntity(ids: episodeIds, title: "Winter Is Coming", number: 1, season: 1, firstAired: nil)
    return WatchedShowEntity(show: show, aired: 65, completed: 60, nextEpisode: nextEpisode)
  }

  final class ShowsProgressRepositoryMock: ShowsProgressRepository {
    private let trakt: TraktProvider

    init(trakt: TraktProvider, cache: AnyCache<Int, NSData>) {
      self.trakt = trakt
    }

    func fetchWatchedShows(update: Bool, extended: Extended) -> Observable<[BaseShow]> {
      return trakt.sync.request(.watched(type: .shows, extended: extended)).mapArray(BaseShow.self)
    }

    func fetchShowProgress(update: Bool, showId: String, hidden: Bool, specials: Bool, countSpecials: Bool) -> Observable<BaseShow> {
      return trakt.shows.request(.watchedProgress(showId: showId, hidden: hidden, specials: specials, countSpecials: countSpecials)).mapObject(BaseShow.self)
    }

    func fetchDetailsOf(update: Bool, episodeNumber: Int, on seasonNumber: Int, of showId: String, extended: Extended) -> Observable<Episode> {
      return trakt.episodes.request(.summary(showId: showId, season: seasonNumber, episode: episodeNumber, extended: extended)).mapObject(Episode.self)
    }
  }

  final class ShowsProgressViewMock: ShowsProgressView {
    var presenter: ShowsProgressPresenter!
    var updateFinishedInvoked = false
    var showEmptyViewInvoked = false
    var newViewModelAvailableInvoked = false
    var newViewModelAvailableParameters = [Int]()

    func newViewModelAvailable(at index: Int) {
      newViewModelAvailableInvoked = true
      newViewModelAvailableParameters.append(index)
    }

    func updateFinished() {
      updateFinishedInvoked = true
    }

    func showEmptyView() {
      showEmptyViewInvoked = true
    }
  }

  final class EmptyShowsProgressInteractorMock: ShowsProgressInteractor {
    init(repository: ShowsProgressRepository) {}

    func fetchWatchedShowsProgress(update: Bool) -> Observable<WatchedShowEntity> {
      return Observable.empty()
    }
  }

  final class ShowsProgressInteractorMock: ShowsProgressInteractor {
    init(repository: ShowsProgressRepository) {}

    func fetchWatchedShowsProgress(update: Bool) -> Observable<WatchedShowEntity> {
      let entity1 = ShowsProgressMocks.mockWatchedShowEntity()
      let entity2 = ShowsProgressMocks.mockWatchedShowEntityWithoutNextEpisode()
      let entity3 = ShowsProgressMocks.mockWatchedShowEntityWithoutNextEpisodeDate()

      return Observable.from([entity1, entity2, entity3])
    }
  }
}
