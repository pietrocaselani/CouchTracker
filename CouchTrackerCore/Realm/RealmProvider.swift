import RealmSwift

public protocol RealmProvider: class {
  var realm: Realm { get }
}
