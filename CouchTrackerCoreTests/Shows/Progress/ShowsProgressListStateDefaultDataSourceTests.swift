@testable import CouchTrackerCore
import XCTest

final class ShowsProgressListStateDefaultDataSourceTests: XCTestCase {
    private var userDefaults: UserDefaults!
    private var dataSource: ShowsProgressListStateDataSource!

    override func setUp() {
        super.setUp()

        userDefaults = UserDefaults(suiteName: "ShowsProgressListStateDefaultDataSourceTests")
        userDefaults.clear()

        dataSource = ShowsProgressListStateDefaultDataSource(userDefaults: userDefaults)
    }

    override func tearDown() {
        super.tearDown()

        userDefaults = nil
        dataSource = nil
    }

    func testShowsProgressListStateDefaultDataSourceTests_returnsInitialStateIfEmpty() {
        // When
        let listState = dataSource.currentState

        // Then
        XCTAssertEqual(listState, ShowProgressListState.initialState)
    }

    func testShowsProgressListStateDefaultDataSourceTests_returnsStateIfNotEmpty() {
        // Given
        userDefaults.set(ShowProgressSort.lastWatched.rawValue, forKey: "ShowsProgressListState-sort")
        userDefaults.set(ShowProgressFilter.watched.rawValue, forKey: "ShowsProgressListState-filter")
        userDefaults.set(ShowProgressDirection.asc.rawValue, forKey: "ShowsProgressListState-direction")

        // When
        let listState = dataSource.currentState

        // Then
        let expectedState = ShowProgressListState(sort: .lastWatched, filter: .watched, direction: .asc)
        XCTAssertEqual(listState, expectedState)
    }

    func testShowsProgressListStateDefaultDataSourceTests_shouldSaveState() {
        // Given
        let newListState = ShowProgressListState(sort: .remaining, filter: .none, direction: .desc)

        // When
        dataSource.currentState = newListState

        // Then
        let sortString = userDefaults.string(forKey: "ShowsProgressListState-sort")
        let filterString = userDefaults.string(forKey: "ShowsProgressListState-filter")
        let directionString = userDefaults.string(forKey: "ShowsProgressListState-direction")

        XCTAssertEqual(sortString, ShowProgressSort.remaining.rawValue)
        XCTAssertEqual(filterString, ShowProgressFilter.none.rawValue)
        XCTAssertEqual(directionString, ShowProgressDirection.desc.rawValue)
    }
}
