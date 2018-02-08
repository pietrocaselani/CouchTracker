import RealmSwift

final class ShowEpisodeRealmDataSource: ShowEpisodeDataSource {
  private let realmProvider: RealmProvider

  init(realmProvider: RealmProvider) {
    self.realmProvider = realmProvider
  }

  func updateWatched(show: WatchedShowEntity) throws {
    let realm = realmProvider.realm

    try realm.write {
      realm.add(show.toRealm(), update: true)
    }
  }
}
