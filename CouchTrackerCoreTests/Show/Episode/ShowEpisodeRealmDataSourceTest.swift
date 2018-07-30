@testable import CouchTrackerCore
import RealmSwift
import TraktSwift
import XCTest

final class ShowEpisodeRealmDataSourceTest: XCTestCase {
    private var realmProvider: RealmProvider!

    override func setUp() {
        super.setUp()

        var testableConfiguration = Realm.Configuration()
        testableConfiguration.inMemoryIdentifier = name

        realmProvider = DefaultRealmProvider(buildConfig: TestBuildConfig(), configuration: testableConfiguration)
        deleteAllTheThingsFromRealm()
    }

    override func tearDown() {
        deleteAllTheThingsFromRealm()
        realmProvider = nil

        super.tearDown()
    }

    private func deleteAllTheThingsFromRealm() {
        let realm = realmProvider.realm

        if realm.isInWriteTransaction {
            realm.deleteAll()
        } else {
            try! realm.write {
                realm.deleteAll()
            }
        }
    }

    func testShowEpisodeRealmDataSource_addEntity() {
        // Given
        let realm = realmProvider.realm
        XCTAssertTrue(realm.isEmpty)
        let dataSource = ShowEpisodeRealmDataSource(realmProvider: realmProvider)

        // When
        let show = ShowsProgressMocks.mockWatchedShowEntityWithoutNextEpisode()
        do {
            try dataSource.updateWatched(show: show)
        } catch {
            XCTFail(error.localizedDescription)
        }

        // Then
        XCTAssertFalse(realm.isEmpty)
        let objects = realm.objects(WatchedShowEntityRealm.self)
        XCTAssertEqual(objects.count, 1)
        XCTAssertEqual(objects.toArray(), [show.toRealm()])
    }

    func testShowEpisodeRealmDataSource_updateEntity() {
        // Given
        let realm = realmProvider.realm
        XCTAssertTrue(realm.isEmpty)
        let dataSource = ShowEpisodeRealmDataSource(realmProvider: realmProvider)

        var objects = realm.objects(WatchedShowEntityRealm.self)
        XCTAssertTrue(objects.isEmpty)

        let show = ShowsProgressMocks.mockWatchedShowEntityWithoutNextEpisodeDate()
        try! realm.write {
            realm.add(show.toRealm(), update: true)
        }

        let builder = show.newBuilder()
        let nextEpisodeDate = Date(timeIntervalSince1970: 200)
        let ids = ShowIds(trakt: 46263, tmdb: 46533, imdb: "tt2149175", slug: "the-americans-2013", tvdb: 261_690, tvrage: 30449)
        let episodeIds = EpisodeIds(trakt: 73640, tmdb: 63056, imdb: "tt1480055", tvdb: 3_254_641, tvrage: 1_065_008_299)
        let nextEpisode = EpisodeEntity(ids: episodeIds, showIds: ids, title: "Winter Is Coming", overview: "Ned Stark, Lord of Winterfell learns that his mentor, Jon Arryn, has died and that King Robert is on his way north to offer Ned Arryn’s position as the King’s Hand. Across the Narrow Sea in Pentos, Viserys Targaryen plans to wed his sister Daenerys to the nomadic Dothraki warrior leader, Khal Drogo to forge an alliance to take the throne.", number: 1, season: 1, firstAired: nextEpisodeDate, lastWatched: nil)

        builder.nextEpisode = nextEpisode

        let newShow = builder.build()

        // When
        do {
            try dataSource.updateWatched(show: newShow)
        } catch {
            XCTFail(error.localizedDescription)
        }

        // Then
        XCTAssertFalse(realm.isEmpty)
        objects = realm.objects(WatchedShowEntityRealm.self)
        XCTAssertEqual(objects.count, 1)
        XCTAssertEqual(objects.toArray(), [newShow.toRealm()])
    }
}
