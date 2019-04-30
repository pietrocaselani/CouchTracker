import Cartography

public final class LoadingButton: View {
  public let button: UIButton = {
    UIButton()
  }()

  private let spinner: UIActivityIndicatorView = {
    UIActivityIndicatorView(style: .white)
  }()

  public var isLoading: Bool = false {
    didSet {
      update(loading: isLoading)
    }
  }

  private func update(loading: Bool) {
    if loading {
      spinner.startAnimating()
    } else {
      spinner.stopAnimating()
    }

    spinner.isHidden = !loading
    button.isHidden = loading
  }

  public override func initialize() {
    update(loading: false)

    addSubview(spinner)
    addSubview(button)
  }

  public override func installConstraints() {
    constrain(button, spinner) { button, spinner in
      button.center == button.superview!.center
      spinner.center == spinner.superview!.center
      button.height == button.superview!.height
    }
  }
}
