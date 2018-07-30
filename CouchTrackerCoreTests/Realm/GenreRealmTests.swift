@testable import CouchTrackerCore
import XCTest

final class GenreRealmTests: XCTestCase {
    func testGenreRealm_can_create_entity() {
        // Given
        let realmEntity = GenreRealm()
        realmEntity.name = "Pietro"
        realmEntity.slug = "PC"

        // When
        let entity = realmEntity.toEntity()

        // Then
        XCTAssertEqual(realmEntity.name, entity.name)
        XCTAssertEqual(realmEntity.slug, entity.slug)
    }
}
