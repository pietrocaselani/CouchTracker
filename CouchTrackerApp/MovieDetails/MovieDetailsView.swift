import Cartography

public final class MovieDetailsView: View {
  public var didTouchOnPoster: (() -> Void)?
  public var didTouchOnBackdrop: (() -> Void)?
  public var didTouchOnWatch: (() -> Void)?

  // Public Views

  public lazy var posterImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = UIView.ContentMode.scaleAspectFill
    return imageView
  }()

  public lazy var backdropImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = UIView.ContentMode.scaleAspectFill
    imageView.isUserInteractionEnabled = true
    imageView.addGestureRecognizer(tapGesture(using: #selector(didTapOnBackdrop)))
    return imageView
  }()

  public lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 22)
    label.textColor = .white
    label.numberOfLines = 0
    return label
  }()

  public lazy var taglineLabel: UILabel = {
    let label = UILabel()
    label.textColor = .lightGray
    label.numberOfLines = 0
    return label
  }()

  public lazy var overviewLabel: UILabel = {
    let label = UILabel()
    label.textColor = .lightGray
    label.numberOfLines = 0
    return label
  }()

  public lazy var genresLabel: UILabel = {
    let label = UILabel()
    label.textColor = .lightGray
    label.numberOfLines = 0
    label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
    return label
  }()

  public lazy var releaseDateLabel: UILabel = {
    let label = UILabel()
    label.textColor = .lightGray
    return label
  }()

  public lazy var watchedAtLabel: UILabel = {
    let label = UILabel()
    label.textColor = .lightGray
    return label
  }()

  public lazy var watchButton: UIButton = {
    let button = UIButton()
    button.addTarget(self, action: #selector(didTapOnWatch), for: .touchUpInside)
    return button
  }()

  // Private Views

  private lazy var scrollView: UIScrollView = {
    UIScrollView()
  }()

  private lazy var posterShadowView: UIView = {
    let view = UIView()
    view.backgroundColor = .black
    view.alpha = 0.75
    return view
  }()

  private lazy var contentStackView: UIStackView = {
    let subviews = [backdropImageView, titleLabel, taglineLabel, overviewLabel,
                    genresLabel, releaseDateLabel, watchedAtLabel, watchButton]
    let stackView = UIStackView(arrangedSubviews: subviews)

    let spacing: CGFloat = 20

    stackView.axis = .vertical
    stackView.alignment = .fill
    stackView.spacing = spacing
    stackView.distribution = .equalSpacing
    stackView.layoutMargins = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.addGestureRecognizer(tapGesture(using: #selector(didTapOnPoster)))

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
      content.top == content.superview!.top + 20
      content.leading == content.superview!.leading
      content.bottom == content.superview!.bottom
      content.trailing == content.superview!.trailing
    }
  }

  private func tapGesture(using selector: Selector) -> UITapGestureRecognizer {
    return UITapGestureRecognizer(target: self, action: selector)
  }

  @objc private func didTapOnPoster() {
    didTouchOnPoster?()
  }

  @objc private func didTapOnBackdrop() {
    didTouchOnBackdrop?()
  }

  @objc private func didTapOnWatch() {
    didTouchOnWatch?()
  }
}
