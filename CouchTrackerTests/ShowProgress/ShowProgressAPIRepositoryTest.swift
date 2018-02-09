import XCTest
import RxSwift
import RxTest
import Moya
import TraktSwift

final class ShowProgressAPIRepositoryTest: XCTestCase {
  private var traktMock: TraktProvider!

  override func setUp() {
    super.setUp()

    traktMock = TraktProviderMock2()
  }

  func testShowProgressAPIRepository_fetchShowProgress_withoutNextEpisode() {
    let repository = ShowProgressAPIRepository(trakt: traktMock)

    let showIds = ShowsProgressMocks.createWatchedShowsMock().first?.show?.ids

    let testExpectation = expectation(description: "Should returns a builder without next episode")

    _ = repository.fetchShowProgress(ids: showIds!).subscribe(onSuccess: { builder in
      testExpectation.fulfill()
      XCTAssertNotNil(builder.detailShow)
      XCTAssertNil(builder.episode)
    }) { error in
      XCTFail(error.localizedDescription)
    }

    wait(for: [testExpectation], timeout: 1)
  }

  fileprivate final class TraktProviderMock2: TraktProvider {
    var oauth: URL? = nil

    var movies: MoyaProvider<Movies> = MoyaProviderMock<Movies>(stubClosure: MoyaProvider.immediatelyStub)
    var genres: MoyaProvider<Genres> = MoyaProviderMock<Genres>(stubClosure: MoyaProvider.immediatelyStub)
    var search: MoyaProvider<Search> = MoyaProviderMock<Search>(stubClosure: MoyaProvider.immediatelyStub)
    var users: MoyaProvider<Users> = MoyaProviderMock<Users>(stubClosure: MoyaProvider.immediatelyStub)
    var authentication: MoyaProvider<Authentication> = MoyaProviderMock<Authentication>(stubClosure: MoyaProvider.immediatelyStub)
    var sync: MoyaProvider<Sync> = MoyaProviderMock<Sync>(stubClosure: MoyaProvider.immediatelyStub)
    var episodes: MoyaProvider<Episodes> = MoyaProviderMock<Episodes>(stubClosure: MoyaProvider.immediatelyStub)
    var shows: MoyaProvider<Shows> = MoyaProviderMock<Shows>(endpointClosure: { (shows) -> Endpoint<Shows> in
      let endpoint = MoyaProvider<Shows>.defaultEndpointMapping(for: shows)

      let data = TraktEntitiesMock.traktDataForJSON(with: "trakt_shows_watchedprogress_without_nextepisode")

      return Endpoint(url: endpoint.url,
                                 sampleResponseClosure: { .networkResponse(200, data) },
                                 method: endpoint.method,
                                 task: endpoint.task,
                                 httpHeaderFields: endpoint.httpHeaderFields)

    }, stubClosure: MoyaProvider.immediatelyStub)

    func finishesAuthentication(with request: URLRequest) -> Single<AuthenticationResult> {
      return Single.just(AuthenticationResult.authenticated)
    }
  }
}
