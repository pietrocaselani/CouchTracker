import UIKit

class View: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  required init() {
    super.init(frame: CGRect.zero)
    setup()
  }

  func initialize() {}

  func installConstraints() {}

  private func setup() {
    initialize()
    installConstraints()
  }
}
