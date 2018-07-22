import XCTest
import RxSwift
import RxTest
import Moya
import TraktSwift
@testable import CouchTrackerCore

final class ShowProgressAPIRepositoryTest: XCTestCase {
	private var traktMock: TraktProvider!

	func testShowProgressAPIRepository_fetchShowProgress_withoutNextEpisode() {
		traktMock = TraktProviderMock2(showsName: "trakt_shows_watchedprogress_without_nextepisode")
		let repository = ShowProgressAPIRepository(trakt: traktMock)

		let showIds = ShowsProgressMocks.createWatchedShowsMock().first?.show?.ids

		let testExpectation = expectation(description: "Should returns a builder without next episode")

		_ = repository.fetchShowProgress(ids: showIds!, hideSpecials: false).subscribe(onSuccess: { builder in
			testExpectation.fulfill()
			XCTAssertNotNil(builder.progressShow)
			XCTAssertNil(builder.episode)
		}) { error in
			XCTFail(error.localizedDescription)
		}

		wait(for: [testExpectation], timeout: 1)
	}

	func testShowProgressAPIRepository_fetchShowProgress_witNextEpisodeError() {
		traktMock = TraktProviderMock2(episodeName: "trakt_episodes_summary_error")
		let repository = ShowProgressAPIRepository(trakt: traktMock)

		let showIds = ShowsProgressMocks.createWatchedShowsMock().first?.show?.ids

		let testExpectation = expectation(description: "Should returns a builder without next episode")

		_ = repository.fetchShowProgress(ids: showIds!, hideSpecials: false).subscribe(onSuccess: { builder in
			testExpectation.fulfill()
			XCTAssertNotNil(builder.progressShow)
			XCTAssertNil(builder.episode)
		}) { error in
			XCTFail(error.localizedDescription)
		}

		wait(for: [testExpectation], timeout: 1)
	}

	func testShowProgressAPIRepository_fetchShowProgress_witNextEpisode() {
		traktMock = TraktProviderMock2()
		let repository = ShowProgressAPIRepository(trakt: traktMock)

		let showIds = ShowsProgressMocks.createWatchedShowsMock().first?.show?.ids

		let testExpectation = expectation(description: "Should returns a builder with next episode")

		_ = repository.fetchShowProgress(ids: showIds!, hideSpecials: false).subscribe(onSuccess: { builder in
			testExpectation.fulfill()
			XCTAssertNotNil(builder.progressShow)
			XCTAssertNotNil(builder.episode)
		}) { error in
			XCTFail(error.localizedDescription)
		}

		wait(for: [testExpectation], timeout: 1)
	}

	fileprivate final class TraktProviderMock2: TraktProvider {
		private let showsName: String?
		private let episodeName: String?
		var oauth: URL? = nil

		var movies: MoyaProvider<Movies> = MoyaProviderMock<Movies>(stubClosure: MoyaProvider.immediatelyStub)
		var genres: MoyaProvider<Genres> = MoyaProviderMock<Genres>(stubClosure: MoyaProvider.immediatelyStub)
		var search: MoyaProvider<Search> = MoyaProviderMock<Search>(stubClosure: MoyaProvider.immediatelyStub)
		var users: MoyaProvider<Users> = MoyaProviderMock<Users>(stubClosure: MoyaProvider.immediatelyStub)
		var authentication: MoyaProvider<Authentication> = MoyaProviderMock<Authentication>(stubClosure: MoyaProvider.immediatelyStub)
		var sync: MoyaProvider<Sync> = MoyaProviderMock<Sync>(stubClosure: MoyaProvider.immediatelyStub)
		lazy var episodes: MoyaProvider<Episodes> = createProviderWith(json: self.episodeName)
		lazy var shows: MoyaProvider<Shows> = createProviderWith(json: self.showsName)

		init(showsName: String? = nil, episodeName: String? = nil) {
			self.showsName = showsName
			self.episodeName = episodeName
		}

		private func createProviderWith<T: TraktType>(json name: String?) -> MoyaProviderMock<T> {
			return MoyaProviderMock<T>(endpointClosure: { (target) -> Endpoint in
				let endpoint = MoyaProvider<T>.defaultEndpointMapping(for: target)

				guard let jsonName = name else { return endpoint }

				let data = TraktEntitiesMock.traktDataForJSON(with: jsonName)

				return Endpoint(url: endpoint.url,
												sampleResponseClosure: { .networkResponse(200, data) },
												method: endpoint.method,
												task: endpoint.task,
												httpHeaderFields: endpoint.httpHeaderFields)

			}, stubClosure: MoyaProvider.immediatelyStub)
		}

		func finishesAuthentication(with request: URLRequest) -> Single<AuthenticationResult> {
			return Single.just(AuthenticationResult.authenticated)
		}
	}
}
