@testable import CouchTrackerCore

final class BaseViewMock: BaseView {
  let title: String

  init(title: String = "") {
    self.title = title
  }
}
