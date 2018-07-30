import Foundation

extension UserDefaults {
    static func clear(userDefaults: UserDefaults) {
        for (key, _) in userDefaults.dictionaryRepresentation() {
            userDefaults.removeObject(forKey: key)
        }
    }

    func clear() {
        UserDefaults.clear(userDefaults: self)
    }
}
