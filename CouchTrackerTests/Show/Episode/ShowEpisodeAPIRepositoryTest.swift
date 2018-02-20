import XCTest
import RxTest
import RxSwift

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

		let single = repository.addToHistory(of: watchedShow, episode: episodeEntity)
		schedulers.start()

		//Then
		let testExpectation = expectation(description: "Should receive SyncResult fail")
		let expectedResult = SyncResult.fail(error: dataSourceError)

		_ = single.subscribe(onSuccess: { result in
			testExpectation.fulfill()
			XCTAssertEqual(result, expectedResult)
			XCTAssertTrue(network.addToHistoryInvoked)
			XCTAssertTrue(dataSource.updateWatchedShowInvoked)
			XCTAssertFalse(network.removeFromHistoryInvoked)
			XCTAssertTrue(showProgressRepository.fetchShowProgressInvoked)
			guard let hideSpecial = showProgressRepository.fetchShowProgressParameters?.hideSpecial else {
				XCTFail()
				return
			}
			XCTAssertTrue(hideSpecial)
		})

		wait(for: [testExpectation], timeout: 1)
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

		let single = repository.removeFromHistory(of: watchedShow, episode: episodeEntity)
		schedulers.start()

		//Then
		let testExpectation = expectation(description: "Should receive SyncResult fail")
		let expectedResult = SyncResult.fail(error: dataSourceError)

		_ = single.subscribe(onSuccess: { result in
			testExpectation.fulfill()
			XCTAssertEqual(result, expectedResult)
			XCTAssertTrue(network.removeFromHistoryInvoked)
			XCTAssertTrue(dataSource.updateWatchedShowInvoked)
			XCTAssertFalse(network.addToHistoryInvoked)
			XCTAssertTrue(showProgressRepository.fetchShowProgressInvoked)
			guard let hideSpecial = showProgressRepository.fetchShowProgressParameters?.hideSpecial else {
				XCTFail()
				return
			}
			XCTAssertTrue(hideSpecial)
		})

		wait(for: [testExpectation], timeout: 1)
	}

	func testShowEpisodeAPIRepository_addHistoryWithErrorChangingAppStateHideSpecials_requestShowProgressHideSpecialFalse() {
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

		appConfigsObservableMock.chage(state: AppConfigurationsState(loginState: .notLogged, hideSpecials: false))

		//When
		let watchedShow = ShowsProgressMocks.mockWatchedShowEntity()
		let episodeEntity = ShowsProgressMocks.mockEpisodeEntity()

		let single = repository.removeFromHistory(of: watchedShow, episode: episodeEntity)
		schedulers.start()

		//Then
		let testExpectation = expectation(description: "Should invoke fetch show progress with hide special false")

		_ = single.subscribe(onSuccess: { result in
			testExpectation.fulfill()
			XCTAssertTrue(showProgressRepository.fetchShowProgressInvoked)
			guard let hideSpecial = showProgressRepository.fetchShowProgressParameters?.hideSpecial else {
				XCTFail()
				return
			}
			XCTAssertFalse(hideSpecial)
		})

		wait(for: [testExpectation], timeout: 1)
	}
}
