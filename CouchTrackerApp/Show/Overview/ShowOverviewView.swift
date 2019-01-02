import Cartography

public final class ShowOverviewView: View {
  public var didTouchOnPoster: (() -> Void)?
  public var didTouchOnBackdrop: (() -> Void)?

  // Public Views

  public let posterImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = UIView.ContentMode.scaleAspectFill
    imageView.clipsToBounds = true
    return imageView
  }()

  public let backdropImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = UIView.ContentMode.scaleAspectFill
    imageView.isUserInteractionEnabled = true
    imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnBackdrop)))
    return imageView
  }()

  public let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 22)
    label.textColor = Colors.Text.primaryTextColor
    label.numberOfLines = 0
    return label
  }()

  public let statusLabel: UILabel = {
    let label = UILabel()
    label.textColor = Colors.Text.secondaryTextColor
    label.numberOfLines = 0
    return label
  }()

  public let networkLabel: UILabel = {
    let label = UILabel()
    label.textColor = Colors.Text.secondaryTextColor
    label.numberOfLines = 0
    return label
  }()

  public let overviewLabel: UILabel = {
    let label = UILabel()
    label.textColor = Colors.Text.secondaryTextColor
    label.numberOfLines = 0
    return label
  }()

  public let genresLabel: UILabel = {
    let label = UILabel()
    label.textColor = Colors.Text.secondaryTextColor
    label.numberOfLines = 0
    label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
    return label
  }()

  public let releaseDateLabel: UILabel = {
    let label = UILabel()
    label.textColor = Colors.Text.secondaryTextColor
    return label
  }()

  // Private Views

  private let scrollView: UIScrollView = {
    UIScrollView()
  }()

  private let posterShadowView: UIView = {
    let view = UIView()
    view.backgroundColor = .black
    view.alpha = 0.75
    return view
  }()

  private lazy var contentStackView: UIStackView = {
    let subviews = [backdropImageView, titleLabel, statusLabel, networkLabel,
                    overviewLabel, genresLabel, releaseDateLabel]
    let stackView = UIStackView(arrangedSubviews: subviews)

    let spacing: CGFloat = 20

    stackView.axis = .vertical
    stackView.alignment = .fill
    stackView.spacing = spacing
    stackView.distribution = .equalSpacing
    stackView.layoutMargins = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnPoster)))

    return stackView
  }()

  // Setup

  public override func initialize() {
    super.initialize()

    addSubview(posterImageView)
    addSubview(posterShadowView)

    scrollView.addSubview(contentStackView)

    addSubview(scrollView)
  }

  public override func installConstraints() {
    super.installConstraints()

    constrain(scrollView,
              contentStackView,
              posterImageView,
              backdropImageView,
              posterShadowView) { scroll, content, poster, backdrop, shadow in
      scroll.size == scroll.superview!.size

      poster.size == poster.superview!.size
      shadow.size == shadow.superview!.size

      backdrop.height == scroll.superview!.height * 0.27

      content.width == content.superview!.width
      content.top == content.superview!.top
      content.leading == content.superview!.leading
      content.bottom == content.superview!.bottom
      content.trailing == content.superview!.trailing
    }
  }

  @objc private func didTapOnPoster() {
    didTouchOnPoster?()
  }

  @objc private func didTapOnBackdrop() {
    didTouchOnBackdrop?()
  }
}
