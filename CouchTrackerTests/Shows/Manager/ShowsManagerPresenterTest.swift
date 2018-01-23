import XCTest

final class ShowsManagerPresenterTest: XCTestCase {
  private let view = ShowsManagerViewMock()
  private var moduleSetup: ShowsManagerDataSourceMock!
  private var presenter: ShowsManagerPresenter!

  private func setupWithLoginState(_ loginState: TraktLoginState) {
    let page1 = ShowManagerModulePage(page: BaseViewMock(), title: "Page1")
    let page2 = ShowManagerModulePage(page: BaseViewMock(), title: "Page2")
    let page3 = ShowManagerModulePage(page: BaseViewMock(), title: "Page3")

    moduleSetup = ShowsManagerDataSourceMock(modulePages: [page1, page2, page3])

    let loginObservable = TraktLoginObservableMock(state: loginState)
    presenter = ShowsManageriOSPresenter(view: view, loginObservable: loginObservable, moduleSetup: moduleSetup)
  }

  func testShowsManagerPresenter_notLoggedOnTrakt_notifyRouter() {
    //Given
    setupWithLoginState(.notLogged)

    //When
    presenter.viewDidLoad()

    //Then
    XCTAssertTrue(view.showNeedsTraktLoginInvoked)
  }

  func testShowsManagerPresenter_loggedInOnTrakt_sentOptionsTitleToView() {
    //Given
    setupWithLoginState(.logged)

    //When
    presenter.viewDidLoad()

    //Then
    XCTAssertTrue(view.showPagesInvoked)

    if view.showPagesParameters == nil {
      XCTFail("Parameters can't be nil")
    } else {
      XCTAssertEqual(view.showPagesParameters?.index, 0)
    }

  }
}
