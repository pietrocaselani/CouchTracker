@testable import CouchTrackerCore
import RxSwift
import RxTest
import XCTest

final class TraktLoginPresenterTest: XCTestCase {
  private var view: TraktLoginViewMock!
  private var schedulers: TestSchedulers!

  override func setUp() {
    super.setUp()

    let testScheduler = TestScheduler(initialClock: 0)

    schedulers = TestSchedulers(mainScheduler: testScheduler, scheduler: testScheduler)
    view = TraktLoginViewMock()
  }

  override func tearDown() {
    super.tearDown()

    schedulers = nil
    view = nil
  }

  func testTraktLoginPresenter_fetchLoginURLFails_notifyOutput() {
    // Given
    let message = "Invalid Trakt parameters"
    let userInfo = [NSLocalizedDescriptionKey: message]
    let genericError = NSError(domain: "io.github.pietrocaselani", code: 50, userInfo: userInfo)
    let interactor = TraktLoginErrorInteractorMock(error: genericError)
    let presenter = TraktLoginDefaultPresenter(view: view, interactor: interactor, schedulers: schedulers)

    // When
    presenter.viewDidLoad()
    schedulers.start()

    // Then
    XCTAssertEqual(view.showErrorInvokedCount, 1)
    XCTAssertEqual(view.showErrorLastParemeter?.localizedDescription, message)
  }

  func testTraktLoginPresenter_fetchLoginURLSuccess_notifyView() {
    // Given
    let url = URL(string: "https://trakt.tv/login")!
    let interactor = TraktLoginInteractorMock(traktProvider: TraktProviderMock(oauthURL: url))
    let presenter = TraktLoginDefaultPresenter(view: view, interactor: interactor, schedulers: schedulers)

    // When
    presenter.viewDidLoad()
    schedulers.start()

    // Then
    XCTAssertTrue(view.invokedLoadLogin)
    XCTAssertEqual(view.invokedLoadLoginParameters?.url, url)
  }
}
