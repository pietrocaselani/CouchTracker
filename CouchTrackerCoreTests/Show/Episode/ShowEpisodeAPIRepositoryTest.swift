@testable import CouchTrackerCore
import Nimble
import RxSwift
import RxTest
import XCTest

final class ShowEpisodeAPIRepositoryTest: XCTestCase {
  func testShowEpisodeAPIRepository_addToHistoryWithError_emitsSyncResultFail() {
    // Given
    let dataSourceError = NSError(domain: "io.github.pietrocaselani.couchtracker", code: 10, userInfo: nil)
    let dataSource = ShowEpisodeMocks.ShowEpisodeDataSourceErrorMock(error: dataSourceError)
    let network = ShowEpisodeMocks.ShowEpisodeNetworkMock()
    let schedulers = TestSchedulers()
    let appConfigsObservableMock = AppConfigurationsMock.AppConfigurationsObservableMock()

			let showWatchedRepository = ShowProgressMocks.ShowWatchedProgressRepositoryMock()
			let showSeasonsRepository = ShowSeasonsRepositoryMock()

			let watchedSeasonAssembler = WatchedSeasonsAssembler(seasonRepository: showSeasonsRepository, schedulers: schedulers)

			let episodeDetailsRepository = EpisodeDetailsRepositoryMock()
			let genreRepository = GenreRepositoryMock()

			let assembler = WatchedShowEntityAssembler(showProgressRepository: showWatchedRepository, watchedSeasonsAssembler: watchedSeasonAssembler, episodeRepository: episodeDetailsRepository, genreRepository: genreRepository, schedulers: schedulers)

			let repository = ShowEpisodeAPIRepository(dataSource: dataSource,
																																													network: network,
																																													schedulers: schedulers,
																																													assembler: assembler,
																																													appConfigurationsObservable: appConfigsObservableMock,
																																													hideSpecials: true)

    // When
    let watchedShow = ShowsProgressMocks.mockWatchedShowEntity()
    let episodeEntity = ShowsProgressMocks.mockEpisodeEntity()

    let res = schedulers.start {
      repository.addToHistory(of: watchedShow, episode: episodeEntity).asObservable()
    }

    // Then
    let expectedResult = SyncResult.fail(error: dataSourceError)

    let expectedEvent = Recorded.next(203, expectedResult)

    expect(res.events).to(containElementSatisfying({ element -> Bool in
      element == expectedEvent
    }))

    XCTAssertTrue(network.addToHistoryInvoked)
    XCTAssertTrue(dataSource.updateWatchedShowInvoked)
    XCTAssertFalse(network.removeFromHistoryInvoked)
    XCTAssertTrue(showWatchedRepository.fetchShowWatchedProgressInvoked)
    guard let hideSpecial = showWatchedRepository.fetchShowWatchedProgressInvokedParameters?.hideSpecials else {
      XCTFail()
      return
    }
    XCTAssertTrue(hideSpecial)
  }

  func testShowEpisodeAPIRepository_removeFromHistoryWithError_emitsSyncResultFail() {
    // Given
    let dataSourceError = NSError(domain: "io.github.pietrocaselani.couchtracker", code: 10, userInfo: nil)
    let dataSource = ShowEpisodeMocks.ShowEpisodeDataSourceErrorMock(error: dataSourceError)
    let network = ShowEpisodeMocks.ShowEpisodeNetworkMock()
    let schedulers = TestSchedulers()
    let appConfigsObservableMock = AppConfigurationsMock.AppConfigurationsObservableMock()

			let showWatchedRepository = ShowProgressMocks.ShowWatchedProgressRepositoryMock()
			let showSeasonsRepository = ShowSeasonsRepositoryMock()

			let watchedSeasonAssembler = WatchedSeasonsAssembler(seasonRepository: showSeasonsRepository, schedulers: schedulers)

			let episodeDetailsRepository = EpisodeDetailsRepositoryMock()
			let genreRepository = GenreRepositoryMock()

			let assembler = WatchedShowEntityAssembler(showProgressRepository: showWatchedRepository, watchedSeasonsAssembler: watchedSeasonAssembler, episodeRepository: episodeDetailsRepository, genreRepository: genreRepository, schedulers: schedulers)

			let repository = ShowEpisodeAPIRepository(dataSource: dataSource,
																																													network: network,
																																													schedulers: schedulers,
																																													assembler: assembler,
																																													appConfigurationsObservable: appConfigsObservableMock,
																																													hideSpecials: true)

    // When
    let watchedShow = ShowsProgressMocks.mockWatchedShowEntity()
    let episodeEntity = ShowsProgressMocks.mockEpisodeEntity()

    let res = schedulers.start {
      repository.removeFromHistory(of: watchedShow, episode: episodeEntity).asObservable()
    }

    // Then
    let expectedResult = SyncResult.fail(error: dataSourceError)
    let expectedEvent = Recorded.next(203, expectedResult)

    expect(res.events).to(containElementSatisfying({ element -> Bool in
      element == expectedEvent
    }))

    XCTAssertTrue(network.removeFromHistoryInvoked)
    XCTAssertTrue(dataSource.updateWatchedShowInvoked)
    XCTAssertFalse(network.addToHistoryInvoked)
    XCTAssertTrue(showWatchedRepository.fetchShowWatchedProgressInvoked)
    guard let hideSpecial = showWatchedRepository.fetchShowWatchedProgressInvokedParameters?.hideSpecials else {
      XCTFail()
      return
    }
    XCTAssertTrue(hideSpecial)
  }

  func testShowEpisodeAPIRepository_removeFromHistoryWithErrorChangingAppStateHideSpecials_requestShowProgressHideSpecialFalse() {
    // Given
    let dataSourceError = NSError(domain: "io.github.pietrocaselani.couchtracker", code: 10, userInfo: nil)
    let dataSource = ShowEpisodeMocks.ShowEpisodeDataSourceErrorMock(error: dataSourceError)
    let network = ShowEpisodeMocks.ShowEpisodeNetworkMock()
    let schedulers = TestSchedulers()
    let appConfigsObservableMock = AppConfigurationsMock.AppConfigurationsObservableMock()

			let showWatchedRepository = ShowProgressMocks.ShowWatchedProgressRepositoryMock()
			let showSeasonsRepository = ShowSeasonsRepositoryMock()

			let watchedSeasonAssembler = WatchedSeasonsAssembler(seasonRepository: showSeasonsRepository, schedulers: schedulers)

			let episodeDetailsRepository = EpisodeDetailsRepositoryMock()
			let genreRepository = GenreRepositoryMock()

			let assembler = WatchedShowEntityAssembler(showProgressRepository: showWatchedRepository, watchedSeasonsAssembler: watchedSeasonAssembler, episodeRepository: episodeDetailsRepository, genreRepository: genreRepository, schedulers: schedulers)

			let repository = ShowEpisodeAPIRepository(dataSource: dataSource,
																																													network: network,
																																													schedulers: schedulers,
																																													assembler: assembler,
																																													appConfigurationsObservable: appConfigsObservableMock,
																																													hideSpecials: true)

    appConfigsObservableMock.change(state: AppConfigurationsState(loginState: .notLogged, hideSpecials: false))

    // When
    let watchedShow = ShowsProgressMocks.mockWatchedShowEntity()
    let episodeEntity = ShowsProgressMocks.mockEpisodeEntity()

    _ = schedulers.start {
      repository.removeFromHistory(of: watchedShow, episode: episodeEntity).asObservable()
    }

    // Then
    XCTAssertTrue(showWatchedRepository.fetchShowWatchedProgressInvoked)
    guard let hideSpecial = showWatchedRepository.fetchShowWatchedProgressInvokedParameters?.hideSpecials else {
      XCTFail()
      return
    }
    XCTAssertFalse(hideSpecial)
  }

	// Failing because doesn't emit the show with seasons!
  func testShowEpisodeAPIRepository_addToHistorSuccess_emitsSyncResultWithShow() {
    // Given
    let dataSource = ShowEpisodeMocks.ShowEpisodeDataSourceMock()
    let network = ShowEpisodeMocks.ShowEpisodeNetworkMock()
    let schedulers = TestSchedulers()
    let appConfigsObservableMock = AppConfigurationsMock.AppConfigurationsObservableMock()

			let showWatchedRepository = ShowProgressMocks.ShowWatchedProgressRepositoryMock()
			let showSeasonsRepository = ShowSeasonsRepositoryMock()

			let watchedSeasonAssembler = WatchedSeasonsAssembler(seasonRepository: showSeasonsRepository, schedulers: schedulers)

			let episodeDetailsRepository = EpisodeDetailsRepositoryMock()
			let genreRepository = GenreRepositoryMock()

			let assembler = WatchedShowEntityAssembler(showProgressRepository: showWatchedRepository, watchedSeasonsAssembler: watchedSeasonAssembler, episodeRepository: episodeDetailsRepository, genreRepository: genreRepository, schedulers: schedulers)

			let repository = ShowEpisodeAPIRepository(dataSource: dataSource,
																																													network: network,
																																													schedulers: schedulers,
																																													assembler: assembler,
																																													appConfigurationsObservable: appConfigsObservableMock,
																																													hideSpecials: true)

    // When
    let watchedShow = ShowsProgressMocks.mockWatchedShowEntity()
    let episodeEntity = ShowsProgressMocks.mockEpisodeEntity()

    let res = schedulers.start {
      repository.addToHistory(of: watchedShow, episode: episodeEntity).asObservable()
    }

    // Then
    let expectedResult = SyncResult.success(show: ShowsProgressMocks.mockWatchedShowEntityWithoutNextEpisode())
    let expectedEvent = Recorded.next(203, expectedResult)

    expect(res.events).to(containElementSatisfying({ element -> Bool in
      element == expectedEvent
    }))

    XCTAssertTrue(network.addToHistoryInvoked)
    XCTAssertTrue(dataSource.updateWatchedShowInvoked)
    XCTAssertFalse(network.removeFromHistoryInvoked)
    XCTAssertTrue(showWatchedRepository.fetchShowWatchedProgressInvoked)
    guard let hideSpecial = showWatchedRepository.fetchShowWatchedProgressInvokedParameters?.hideSpecials else {
      XCTFail()
      return
    }
    XCTAssertTrue(hideSpecial)
  }

	// Failing because doesn't emit the show with seasons!
  func testShowEpisodeAPIRepository_removeFromHistorSuccess_emitsSyncResultWithShow() {
    // Given
    let dataSource = ShowEpisodeMocks.ShowEpisodeDataSourceMock()
    let network = ShowEpisodeMocks.ShowEpisodeNetworkMock()
    let schedulers = TestSchedulers()
    let appConfigsObservableMock = AppConfigurationsMock.AppConfigurationsObservableMock()

			let showWatchedRepository = ShowProgressMocks.ShowWatchedProgressRepositoryMock()
			let showSeasonsRepository = ShowSeasonsRepositoryMock()

			let watchedSeasonAssembler = WatchedSeasonsAssembler(seasonRepository: showSeasonsRepository, schedulers: schedulers)

			let episodeDetailsRepository = EpisodeDetailsRepositoryMock()
			let genreRepository = GenreRepositoryMock()

			let assembler = WatchedShowEntityAssembler(showProgressRepository: showWatchedRepository, watchedSeasonsAssembler: watchedSeasonAssembler, episodeRepository: episodeDetailsRepository, genreRepository: genreRepository, schedulers: schedulers)

			let repository = ShowEpisodeAPIRepository(dataSource: dataSource,
																																													network: network,
																																													schedulers: schedulers,
																																													assembler: assembler,
																																													appConfigurationsObservable: appConfigsObservableMock,
																																													hideSpecials: true)

    // When
    let watchedShow = ShowsProgressMocks.mockWatchedShowEntity()
    let episodeEntity = ShowsProgressMocks.mockEpisodeEntity()

    let res = schedulers.start {
      repository.removeFromHistory(of: watchedShow, episode: episodeEntity).asObservable()
    }

    // Then
    let expectedResult = SyncResult.success(show: ShowsProgressMocks.mockWatchedShowEntityWithoutNextEpisode())
    let expectedEvent = Recorded.next(203, expectedResult)

    expect(res.events).to(containElementSatisfying({ element -> Bool in
      element == expectedEvent
    }))

    XCTAssertFalse(network.addToHistoryInvoked)
    XCTAssertTrue(dataSource.updateWatchedShowInvoked)
    XCTAssertTrue(network.removeFromHistoryInvoked)
    XCTAssertTrue(showWatchedRepository.fetchShowWatchedProgressInvoked)
    guard let hideSpecial = showWatchedRepository.fetchShowWatchedProgressInvokedParameters?.hideSpecials else {
      XCTFail()
      return
    }
    XCTAssertTrue(hideSpecial)
  }
}
