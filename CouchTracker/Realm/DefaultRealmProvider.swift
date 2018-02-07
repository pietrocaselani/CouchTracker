import RealmSwift
import RxSwift

final class DefaultRealmProvider: RealmProvider {
  private let configuration: Realm.Configuration

  init(configuration: Realm.Configuration = Realm.Configuration.defaultConfiguration) {
    self.configuration = configuration
  }

  lazy var realm: Realm = {
    do {
      let instance = try Realm(configuration: configuration)

      return instance
    } catch {
      fatalError("Could not open Realm due to error: \(error.localizedDescription)")
    }
  }()
}
