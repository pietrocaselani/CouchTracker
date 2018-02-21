import XCTest
import RxSwift
@testable import CouchTrackerCore

final class TraktLoginInteractorTest: XCTestCase {
	private let disposeBag = CompositeDisposable()

	override func tearDown() {
		disposeBag.dispose()
		super.tearDown()
	}

	func testTraktLoginInteractor_createInstanceFailsWithoutOAuthURL() {
		let interactor = TraktLoginService(traktProvider: TraktProviderMock(oauthURL: nil))
		XCTAssertNil(interactor)
	}

	func testTraktLoginInteractor_fetchLoginURLSuccess_emitsURL() {
		//Given
		let url = URL(string: "https://google.com/login")
		let interactor = TraktLoginService(traktProvider: TraktProviderMock(oauthURL: url))!

		//When
		let single = interactor.fetchLoginURL()

		//Then
		let resultExpectation = expectation(description: "Expect login URL")

		let disposable = single.subscribe(onSuccess: { resultURL in
			resultExpectation.fulfill()
			XCTAssertEqual(resultURL, url)
		})
		_ = disposeBag.insert(disposable)

		wait(for: [resultExpectation], timeout: 1)
	}
}
