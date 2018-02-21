import RxSwift
import XCTest
@testable import CouchTrackerCore

final class TraktLoginPresenterTest: XCTestCase {
	private let view = TraktLoginViewMock()
	private let output = TraktLoginOutputMock()

	func testTraktLoginPresenter_fetchLoginURLFails_notifyOutput() {
		//Given
		let message = "Invalid Trakt parameters"
		let userInfo = [NSLocalizedDescriptionKey: message]
		let genericError = NSError(domain: "io.github.pietrocaselani", code: 50, userInfo: userInfo)
		let interactor = TraktLoginErrorInteractorMock(error: genericError)
		let presenter = TraktLoginDefaultPresenter(view: view, interactor: interactor, output: output)

		//When
		presenter.viewDidLoad()

		//Then
		XCTAssertTrue(output.invokedLogInFail)
		XCTAssertEqual(output.invokedLoginFailParameters?.message, message)
	}

	func testTraktLoginPresenter_fetchLoginURLSuccess_notifyView() {
		//Given
		let url = URL(string: "https://trakt.tv/login")!
		let interactor = TraktLoginInteractorMock(traktProvider: TraktProviderMock(oauthURL: url))
		let presenter = TraktLoginDefaultPresenter(view: view, interactor: interactor, output: output)

		//When
		presenter.viewDidLoad()

		//Then
		XCTAssertTrue(view.invokedLoadLogin)
		XCTAssertEqual(view.invokedLoadLoginParameters?.url, url)
	}
}
