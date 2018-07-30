import RealmSwift

public final class ShowEpisodeRealmDataSource: ShowEpisodeDataSource {
    private let realmProvider: RealmProvider

    public init(realmProvider: RealmProvider) {
        self.realmProvider = realmProvider
    }

    public func updateWatched(show: WatchedShowEntity) throws {
        let realm = realmProvider.realm

        try realm.write {
            realm.add(show.toRealm(), update: true)
        }
    }
}
