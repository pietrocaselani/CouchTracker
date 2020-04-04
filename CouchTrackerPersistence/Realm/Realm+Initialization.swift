import RealmSwift
import RxRealm
import RxSwift

public final class RealmInitialization: Object {
  @objc public dynamic var name = ""

  public override static func primaryKey() -> String? {
    "name"
  }
}

private final class RealmInitializationObservable {
  private static var observables = [String: BehaviorSubject<Bool>]()

  private init() {}

  static func observe(realm: Realm, type: Object.Type) -> Observable<Bool> {
    let objectName = String(describing: type)

    guard let subject = observables[objectName] else {
      let realmObject = realm.object(ofType: RealmInitialization.self, forPrimaryKey: objectName)
      let newSubject = BehaviorSubject<Bool>(value: realmObject != nil)
      observables[objectName] = newSubject
      return newSubject
    }

    return subject
  }

  static func initialize(type: Object.Type) {
    let objectName = String(describing: type)

    guard let subject = observables[objectName] else { return }

    subject.onNext(true)
  }
}

public enum RealmObjectState<T> {
  case notInitialized
  case available(value: T)
}

public extension Realm {
  func isInitialized(_ type: Object.Type) -> Bool {
    let objectName = String(describing: type)
    return object(ofType: RealmInitialization.self, forPrimaryKey: objectName) != nil
  }

  func observeInitialization(of type: Object.Type) -> Observable<Bool> {
    RealmInitializationObservable.observe(realm: self, type: type)
  }

  func observeArray<T: Object>(of type: T.Type) -> Observable<RealmObjectState<[T]>> {
    observeInitialization(of: type)
      .flatMap { initialized -> Observable<RealmObjectState<[T]>> in
        guard initialized else { return .just(.notInitialized) }

        let results = self.objects(type)
        return Observable.array(from: results).map { RealmObjectState.available(value: $0) }
      }
  }

  func observeObject<T: Object, KeyType>(of type: T.Type, primaryKey: KeyType) -> Observable<T> {
    observeInitialization(of: type)
      .flatMap { initialized -> Observable<T> in
        guard initialized else { return Observable.empty() }

        guard let object = self.object(ofType: type, forPrimaryKey: primaryKey) else {
          return Observable.empty()
        }

        return Observable.from(object: object, emitInitialValue: true)
      }
  }

  func initializeAndAdd(_ object: Object, update: Bool = true) throws {
    try write {
      add(object, update: .modified)
      initialize(objectType: type(of: object))
    }

    RealmInitializationObservable.initialize(type: type(of: object))
  }

  func initializeAndAdd<S: Sequence>(_ objects: S, update: Bool = true) throws where S.Iterator.Element: Object {
    let objectType = S.Iterator.Element.self
    try write {
      add(objects, update: .modified)
      initialize(objectType: objectType)
    }

    RealmInitializationObservable.initialize(type: objectType)
  }

  private func initialize(objectType: Object.Type) {
    let objectName = String(describing: objectType)
    let initializationObject = RealmInitialization()
    initializationObject.name = objectName

    add(initializationObject, update: .modified)
  }
}
