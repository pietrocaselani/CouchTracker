import Cartography

public final class ShowEpisodeView: View {
  public var didTouchOnPreview: (() -> Void)?
  public var didTouchOnWatch: (() -> Void)?

  // Public Views

  public let posterImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = UIView.ContentMode.scaleAspectFill
    imageView.clipsToBounds = true
    return imageView
  }()

  public let previewImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = UIView.ContentMode.scaleAspectFill
    imageView.isUserInteractionEnabled = true
    imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnPreview)))
    imageView.clipsToBounds = true
    return imageView
  }()

  public let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 22)
    label.textColor = Colors.Text.primaryTextColor
    label.numberOfLines = 0
    return label
  }()

  public let overviewLabel: UILabel = {
    let label = UILabel()
    label.textColor = Colors.Text.secondaryTextColor
    label.numberOfLines = 0
    return label
  }()

  public let releaseDateLabel: UILabel = {
    let label = UILabel()
    label.textColor = Colors.Text.secondaryTextColor
    return label
  }()

  public let watchedAtLabel: UILabel = {
    let label = UILabel()
    label.textColor = Colors.Text.secondaryTextColor
    return label
  }()

  public let seasonAndNumberLabel: UILabel = {
    let label = UILabel()
    label.textColor = Colors.Text.secondaryTextColor
    return label
  }()

  public lazy var watchButton: LoadingButton = {
    let view = LoadingButton()
    view.button.addTarget(self, action: #selector(didTapOnWatch), for: .touchUpInside)
    return view
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
    let subviews = [previewImageView, titleLabel, overviewLabel,
                    releaseDateLabel, seasonAndNumberLabel, watchedAtLabel, watchButton]
    let stackView = UIStackView(arrangedSubviews: subviews)

    let spacing: CGFloat = 20

    stackView.axis = .vertical
    stackView.alignment = .fill
    stackView.spacing = spacing
    stackView.distribution = .equalSpacing
    stackView.layoutMargins = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.isUserInteractionEnabled = true

    return stackView
  }()

  // Setup

  public override func initialize() {
    super.initialize()

    backgroundColor = Colors.View.background

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
              previewImageView,
              posterShadowView) { scroll, content, poster, preview, shadow in
      scroll.size == scroll.superview!.size

      poster.size == poster.superview!.size
      shadow.size == shadow.superview!.size

      preview.height == scroll.superview!.height * 0.27

      content.width == content.superview!.width
      content.top == content.superview!.top
      content.leading == content.superview!.leading
      content.bottom == content.superview!.bottom
      content.trailing == content.superview!.trailing
    }
  }

  @objc private func didTapOnPreview() {
    didTouchOnPreview?()
  }

  @objc private func didTapOnWatch() {
    didTouchOnWatch?()
  }
}
