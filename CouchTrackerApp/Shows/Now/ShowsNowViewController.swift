import Cartography

final class ShowsNowViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = Colors.View.background

    let label = UILabel()
    label.text = "Now"
    label.textColor = Colors.Text.secondaryTextColor

    view.addSubview(label)

    constrain(label) { label in
      label.center == label.superview!.center
    }
  }
}
