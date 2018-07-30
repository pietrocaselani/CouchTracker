import XCTest

@testable import CouchTrackerCore

final class ShowManagerDefaultDataSourceTest: XCTestCase {
    private var userDefaults: UserDefaults!
    private var creator: ShowManagerModuleCreator!

    override func setUp() {
        super.setUp()

        userDefaults = UserDefaults(suiteName: "ShowManagerDefaultDataSourceTest")
        creator = ShowManagerMocks.ModuleCreator()

        userDefaults.clear()
    }

    override func tearDown() {
        creator = nil
        userDefaults = nil

        super.tearDown()
    }

    func testShowManagerDefaultDataSource_returnsShowTitleWhenPresent() {
        // Given
        let show = ShowsProgressMocks.mockWatchedShowEntity()
        let dataSource = ShowManagerDefaultDataSource(show: show, creator: creator, userDefaults: userDefaults)

        // When
        let title = dataSource.showTitle

        // Then
        XCTAssertEqual(title, "The Americans")
    }

    func testShowManagerDefaultDataSource_returnsNilShowTitleWhenAbsent() {
        // Given
        let show = ShowsProgressMocks.mockWatchedShowEntity(title: nil)
        let dataSource = ShowManagerDefaultDataSource(show: show, creator: creator, userDefaults: userDefaults)

        // When
        let title = dataSource.showTitle

        // Then
        XCTAssertNil(title)
    }

    func testShowManagerDefaultDataSource_returnsOptionsInRightOrder() {
        // Given
        let show = ShowsProgressMocks.mockWatchedShowEntity()
        let dataSource = ShowManagerDefaultDataSource(show: show, creator: creator, userDefaults: userDefaults)

        // When
        let options = dataSource.options

        // Then
        let expectedOptions = [ShowManagerOption.overview, ShowManagerOption.episode, ShowManagerOption.seasons]
        XCTAssertEqual(options, expectedOptions)
    }

    func testShowManagerDefaultDataSource_returnsModulePagesInRightOrder() {
        // Given
        let show = ShowsProgressMocks.mockWatchedShowEntity()
        let dataSource = ShowManagerDefaultDataSource(show: show, creator: creator, userDefaults: userDefaults)

        // When
        let pages = dataSource.modulePages

        // Then
        let expectedPages = ModulePageMocks.createPages(titles: ["Overview", "Episode", "Seasons"])
        XCTAssertEqual(pages, expectedPages)
    }

    func testShowManagerDefaultDataSource_returnsDefaultModuleIndex_whenAbsent() {
        // Given
        let show = ShowsProgressMocks.mockWatchedShowEntity()
        let dataSource = ShowManagerDefaultDataSource(show: show, creator: creator, userDefaults: userDefaults)

        XCTAssertNil(userDefaults.object(forKey: "showManagerLastTab"))

        // When
        let moduleIndex = dataSource.defaultModuleIndex

        // Then
        let defaultModuleIndex = 0
        XCTAssertEqual(moduleIndex, defaultModuleIndex)
    }

    func testShowManagerDefaultDataSource_returnsDefaultModuleIndexFromUserDefaults() {
        // Given
        let show = ShowsProgressMocks.mockWatchedShowEntity()
        let dataSource = ShowManagerDefaultDataSource(show: show, creator: creator, userDefaults: userDefaults)

        userDefaults.set(30, forKey: "showManagerLastTab")

        // When
        let moduleIndex = dataSource.defaultModuleIndex

        // Then
        let expectedIndex = 30
        XCTAssertEqual(moduleIndex, expectedIndex)
    }

    func testShowManagerDefaultDataSource_updateModuleIndexSavesOnUserDefaults() {
        // Given
        let show = ShowsProgressMocks.mockWatchedShowEntity()
        let dataSource = ShowManagerDefaultDataSource(show: show, creator: creator, userDefaults: userDefaults)

        XCTAssertNil(userDefaults.object(forKey: "showManagerLastTab"))

        // When
        dataSource.defaultModuleIndex = 7

        // Then
        let expectedIndex = 7
        let userDefaultsIndex = userDefaults.integer(forKey: "showManagerLastTab")
        XCTAssertEqual(userDefaultsIndex, expectedIndex)
    }
}
