import CouchTrackerAppTestable
import CouchTrackerCore
import KIF

final class AppStartupEnglishUSTests: KIFTestCase {
  func testChangeTabs_enUS() {
    tester().tapView(withAccessibilityLabel: "Shows")
    tester().tapView(withAccessibilityLabel: "Settings")
    tester().tapView(withAccessibilityLabel: "Movies")
  }
}
