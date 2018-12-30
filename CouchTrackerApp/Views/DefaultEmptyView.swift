import Cartography

public final class DefaultEmptyView: View {
  public let label: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.numberOfLines = 0
    label.textColor = Colors.Text.secondaryTextColor
    return label
  }()

  public override func initialize() {
    addSubview(label)
  }

  public override func installConstraints() {
    constrain(label) { label in
      label.center == label.superview!.center
    }
  }
}
