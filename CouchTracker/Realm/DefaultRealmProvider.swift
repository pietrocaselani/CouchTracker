import RealmSwift
import RxSwift

final class DefaultRealmProvider: RealmProvider {
  lazy var realm: Realm = {
    do {
      return try Realm()
    } catch {
      fatalError("Could not open Realm due to error: \(error.localizedDescription)")
    }
  }()
}

extension RealmProvider {
  func asSingle() -> Single<Realm> {
    return Single<Realm>.create(subscribe: { single -> Disposable in
      single(.success(self.realm))
      return Disposables.create()
    })
  }
}
