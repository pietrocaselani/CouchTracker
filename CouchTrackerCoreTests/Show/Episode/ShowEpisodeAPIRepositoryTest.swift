import XCTest
import RxTest
import RxSwift
import Nimble
@testable import CouchTrackerCore

final class ShowEpisodeAPIRepositoryTest: XCTestCase {
	func testShowEpisodeAPIRepository_addToHistoryWithError_emitsSyncResultFail() {
		//Given
		let dataSourceError = NSError(domain: "io.github.pietrocaselani.couchtracker", code: 10, userInfo: nil)
		let dataSource = ShowEpisodeMocks.ShowEpisodeDataSourceErrorMock(error: dataSourceError)
		let network = ShowEpisodeMocks.ShowEpisodeNetworkMock()
		let schedulers = TestSchedulers()
		let showProgressRepository = ShowProgressMocks.ShowProgressRepositoryMock()
		let appConfigsObservableMock = AppConfigurationsMock.AppConfigurationsObservableMock()

		let repository = ShowEpisodeAPIRepository(dataSource: dataSource,
																																												network: network,
																																												schedulers: schedulers,
																																												showProgressRepository: showProgressRepository,
																																												appConfigurationsObservable: appConfigsObservableMock,
																																												hideSpecials: true)

		//When
		let watchedShow = ShowsProgressMocks.mockWatchedShowEntity()
		let episodeEntity = ShowsProgressMocks.mockEpisodeEntity()

		let res = schedulers.start {
			repository.addToHistory(of: watchedShow, episode: episodeEntity).asObservable()
		}

		//Then
		let expectedResult = SyncResult.fail(error: dataSourceError)

		let expectedEvent = next(201, expectedResult)

		expect(res.events).to(containElementSatisfying({ element -> Bool in
			element == expectedEvent
		}))

		XCTAssertTrue(network.addToHistoryInvoked)
		XCTAssertTrue(dataSource.updateWatchedShowInvoked)
		XCTAssertFalse(network.removeFromHistoryInvoked)
		XCTAssertTrue(showProgressRepository.fetchShowProgressInvoked)
		guard let hideSpecial = showProgressRepository.fetchShowProgressParameters?.hideSpecial else {
			XCTFail()
			return
		}
		XCTAssertTrue(hideSpecial)
	}

	func testShowEpisodeAPIRepository_removeFromHistoryWithError_emitsSyncResultFail() {
		//Given
		let dataSourceError = NSError(domain: "io.github.pietrocaselani.couchtracker", code: 10, userInfo: nil)
		let dataSource = ShowEpisodeMocks.ShowEpisodeDataSourceErrorMock(error: dataSourceError)
		let network = ShowEpisodeMocks.ShowEpisodeNetworkMock()
		let schedulers = TestSchedulers()
		let showProgressRepository = ShowProgressMocks.ShowProgressRepositoryMock()
		let appConfigsObservableMock = AppConfigurationsMock.AppConfigurationsObservableMock()

		let repository = ShowEpisodeAPIRepository(dataSource: dataSource,
																																												network: network,
																																												schedulers: schedulers,
																																												showProgressRepository: showProgressRepository,
																																												appConfigurationsObservable: appConfigsObservableMock,
																																												hideSpecials: true)

		//When
		let watchedShow = ShowsProgressMocks.mockWatchedShowEntity()
		let episodeEntity = ShowsProgressMocks.mockEpisodeEntity()

		let res = schedulers.start {
			repository.removeFromHistory(of: watchedShow, episode: episodeEntity).asObservable()
		}

		//Then
		let expectedResult = SyncResult.fail(error: dataSourceError)
		let expectedEvent = next(201, expectedResult)

		expect(res.events).to(containElementSatisfying({ element -> Bool in
			return element == expectedEvent
		}))

		XCTAssertTrue(network.removeFromHistoryInvoked)
		XCTAssertTrue(dataSource.updateWatchedShowInvoked)
		XCTAssertFalse(network.addToHistoryInvoked)
		XCTAssertTrue(showProgressRepository.fetchShowProgressInvoked)
		guard let hideSpecial = showProgressRepository.fetchShowProgressParameters?.hideSpecial else {
			XCTFail()
			return
		}
		XCTAssertTrue(hideSpecial)
	}

	func testShowEpisodeAPIRepository_removeFromHistoryWithErrorChangingAppStateHideSpecials_requestShowProgressHideSpecialFalse() {
		//Given
		let dataSourceError = NSError(domain: "io.github.pietrocaselani.couchtracker", code: 10, userInfo: nil)
		let dataSource = ShowEpisodeMocks.ShowEpisodeDataSourceErrorMock(error: dataSourceError)
		let network = ShowEpisodeMocks.ShowEpisodeNetworkMock()
		let schedulers = TestSchedulers()
		let showProgressRepository = ShowProgressMocks.ShowProgressRepositoryMock()
		let appConfigsObservableMock = AppConfigurationsMock.AppConfigurationsObservableMock()

		let repository = ShowEpisodeAPIRepository(dataSource: dataSource,
																																												network: network,
																																												schedulers: schedulers,
																																												showProgressRepository: showProgressRepository,
																																												appConfigurationsObservable: appConfigsObservableMock,
																																												hideSpecials: true)

		appConfigsObservableMock.change(state: AppConfigurationsState(loginState: .notLogged, hideSpecials: false))

		//When
		let watchedShow = ShowsProgressMocks.mockWatchedShowEntity()
		let episodeEntity = ShowsProgressMocks.mockEpisodeEntity()

		_ = schedulers.start {
			repository.removeFromHistory(of: watchedShow, episode: episodeEntity).asObservable()
		}

		//Then
		XCTAssertTrue(showProgressRepository.fetchShowProgressInvoked)
		guard let hideSpecial = showProgressRepository.fetchShowProgressParameters?.hideSpecial else {
			XCTFail()
			return
		}
		XCTAssertFalse(hideSpecial)
	}

	func testShowEpisodeAPIRepository_addToHistorSuccess_emitsSyncResultWithShow() {
		//Given
		let dataSource = ShowEpisodeMocks.ShowEpisodeDataSourceMock()
		let network = ShowEpisodeMocks.ShowEpisodeNetworkMock()
		let schedulers = TestSchedulers()
		let showProgressRepository = ShowProgressMocks.ShowProgressRepositoryMock()
		let appConfigsObservableMock = AppConfigurationsMock.AppConfigurationsObservableMock()

		let repository = ShowEpisodeAPIRepository(dataSource: dataSource,
																																												network: network,
																																												schedulers: schedulers,
																																												showProgressRepository: showProgressRepository,
																																												appConfigurationsObservable: appConfigsObservableMock,
																																												hideSpecials: true)

		//When
		let watchedShow = ShowsProgressMocks.mockWatchedShowEntity()
		let episodeEntity = ShowsProgressMocks.mockEpisodeEntity()

		let res = schedulers.start {
			repository.addToHistory(of: watchedShow, episode: episodeEntity).asObservable()
		}

		//Then
		let expectedResult = SyncResult.success(show: ShowsProgressMocks.mockWatchedShowEntityWithoutNextEpisode())
		let expectedEvent = next(201, expectedResult)

		expect(res.events).to(containElementSatisfying({ element -> Bool in
			return element == expectedEvent
		}))

		XCTAssertTrue(network.addToHistoryInvoked)
		XCTAssertTrue(dataSource.updateWatchedShowInvoked)
		XCTAssertFalse(network.removeFromHistoryInvoked)
		XCTAssertTrue(showProgressRepository.fetchShowProgressInvoked)
		guard let hideSpecial = showProgressRepository.fetchShowProgressParameters?.hideSpecial else {
			XCTFail()
			return
		}
		XCTAssertTrue(hideSpecial)
	}

	func testShowEpisodeAPIRepository_removeFromHistorSuccess_emitsSyncResultWithShow() {
		//Given
		let dataSource = ShowEpisodeMocks.ShowEpisodeDataSourceMock()
		let network = ShowEpisodeMocks.ShowEpisodeNetworkMock()
		let schedulers = TestSchedulers()
		let showProgressRepository = ShowProgressMocks.ShowProgressRepositoryMock()
		let appConfigsObservableMock = AppConfigurationsMock.AppConfigurationsObservableMock()

		let repository = ShowEpisodeAPIRepository(dataSource: dataSource,
																																												network: network,
																																												schedulers: schedulers,
																																												showProgressRepository: showProgressRepository,
																																												appConfigurationsObservable: appConfigsObservableMock,
																																												hideSpecials: true)

		//When
		let watchedShow = ShowsProgressMocks.mockWatchedShowEntity()
		let episodeEntity = ShowsProgressMocks.mockEpisodeEntity()

		let res = schedulers.start {
			repository.removeFromHistory(of: watchedShow, episode: episodeEntity).asObservable()
		}

		//Then
		let expectedResult = SyncResult.success(show: ShowsProgressMocks.mockWatchedShowEntityWithoutNextEpisode())
		let expectedEvent = next(201, expectedResult)

		expect(res.events).to(containElementSatisfying({ element -> Bool in
			return element == expectedEvent
		}))

		XCTAssertFalse(network.addToHistoryInvoked)
		XCTAssertTrue(dataSource.updateWatchedShowInvoked)
		XCTAssertTrue(network.removeFromHistoryInvoked)
		XCTAssertTrue(showProgressRepository.fetchShowProgressInvoked)
		guard let hideSpecial = showProgressRepository.fetchShowProgressParameters?.hideSpecial else {
			XCTFail()
			return
		}
		XCTAssertTrue(hideSpecial)
	}
}
