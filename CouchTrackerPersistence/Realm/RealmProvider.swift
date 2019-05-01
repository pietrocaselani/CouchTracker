import RealmSwift

public protocol RealmProvider: AnyObject {
  var realm: Realm { get }
}
