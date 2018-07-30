import Foundation

public final class ShowsProgressListStateDefaultDataSource: ShowsProgressListStateDataSource {
    private enum Keys: String {
        case sort = "ShowsProgressListState-sort"
        case filter = "ShowsProgressListState-filter"
        case direction = "ShowsProgressListState-direction"
    }

    private let userDefaults: UserDefaults

    public var currentState: ShowProgressListState {
        get {
            let sortString = userDefaults.string(forKey: Keys.sort.rawValue)
            let filterString = userDefaults.string(forKey: Keys.filter.rawValue)
            let directionString = userDefaults.string(forKey: Keys.direction.rawValue)

            let sort = ShowProgressSort.create(from: sortString)
            let filter = ShowProgressFilter.create(from: filterString)
            let direction = ShowProgressDirection.create(from: directionString)

            return ShowProgressListState(sort: sort, filter: filter, direction: direction)
        }
        set {
            userDefaults.set(newValue.sort.rawValue, forKey: Keys.sort.rawValue)
            userDefaults.set(newValue.filter.rawValue, forKey: Keys.filter.rawValue)
            userDefaults.set(newValue.direction.rawValue, forKey: Keys.direction.rawValue)
        }
    }

    public init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
}
