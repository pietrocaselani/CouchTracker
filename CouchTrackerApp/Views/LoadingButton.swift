import SnapKit

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
    button.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.height.equalToSuperview()
    }

    spinner.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }
}
