import RealmSwift
import RxSwift

final class DefaultRealmProvider: RealmProvider {
  lazy var realm: Realm = {
    do {
      let instance = try Realm()

      if Environment.instance.debug {
        print(instance.configuration.fileURL?.absoluteString ?? "Realm in memory")
      }

      return instance
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
