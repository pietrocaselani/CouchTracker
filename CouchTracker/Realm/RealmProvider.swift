import RealmSwift

protocol RealmProvider: class {
	var realm: Realm { get }
}
