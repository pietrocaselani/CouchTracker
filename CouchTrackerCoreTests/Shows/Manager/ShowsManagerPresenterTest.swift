@testable import CouchTrackerCore
import XCTest

final class ShowsManagerPresenterTest: XCTestCase {
    private let view = ShowsManagerViewMock()
    private var dataSource: ShowsManagerDataSourceMock!
    private var presenter: ShowsManagerPresenter!

    private func setup(_ index: Int = 0) {
        let page1 = ModulePage(page: BaseViewMock(), title: "Page1")
        let page2 = ModulePage(page: BaseViewMock(), title: "Page2")
        let page3 = ModulePage(page: BaseViewMock(), title: "Page3")

        dataSource = ShowsManagerDataSourceMock(modulePages: [page1, page2, page3], index: index)

        presenter = ShowsManagerDefaultPresenter(view: view, moduleSetup: dataSource)
    }

    func testShowsManagerPresenter_initializeWithRightIndex() {
        // Given
        setup(1)

        // When
        presenter.viewDidLoad()

        // Then
        XCTAssertTrue(view.showPagesInvoked)
        XCTAssertEqual(view.showPagesParameters?.index, 1)
        XCTAssertEqual(view.showPagesParameters?.pages.count, 3)
    }

    func testShowsManagerPresenter_selectTab_notifyDataSource() {
        // Given
        setup(0)

        // When
        presenter.selectTab(index: 2)

        //
        XCTAssertTrue(dataSource.defaultModuleIndexInvoked)
        XCTAssertEqual(dataSource.defaultModuleIndexParameter, 2)
    }
}
