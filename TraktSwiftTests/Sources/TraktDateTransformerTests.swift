import TraktSwift
import XCTest

final class TraktDateTransformerTests: XCTestCase {
  func testReceivesNil_returnsNil() {
    XCTAssertNil(TraktDateTransformer.dateTimeTransformer.transformFromJSON(nil))
    XCTAssertNil(TraktDateTransformer.dateTimeTransformer.transformToJSON(nil))
    XCTAssertNil(TraktDateTransformer.dateTransformer.transformToJSON(nil))
    XCTAssertNil(TraktDateTransformer.dateTransformer.transformFromJSON(nil))
  }

  func testCanTransformToJSON() {
    let date = Date(timeIntervalSince1970: 0)

    let dateTimeString = TraktDateTransformer.dateTimeTransformer.transformToJSON(date)
    let dateString = TraktDateTransformer.dateTransformer.transformToJSON(date)

    XCTAssertEqual(dateTimeString, "1970-01-01T00:00:00.000+0000")
    XCTAssertEqual(dateString, "1970-01-01")
  }
}
