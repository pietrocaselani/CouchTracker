import Cartography

public final class DefaultEmptyView: View {
  public let label = UILabel()

  public override func initialize() {
    addSubview(label)
  }

  public override func installConstraints() {
    constrain(label) { label in
      label.center == label.superview!.center
    }
  }
}
