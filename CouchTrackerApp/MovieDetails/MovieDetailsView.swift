import SnapKit

public final class MovieDetailsView: View {
  public var didTouchOnPoster: (() -> Void)?
  public var didTouchOnBackdrop: (() -> Void)?
  public var didTouchOnWatch: (() -> Void)?

  // Public Views

  public let posterImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = UIView.ContentMode.scaleAspectFill
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

  public let taglineLabel: UILabel = {
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

  public let watchedAtLabel: UILabel = {
    let label = UILabel()
    label.textColor = Colors.Text.secondaryTextColor
    return label
  }()

  public let watchButton: UIButton = {
    let button = UIButton()
    button.addTarget(self, action: #selector(didTapOnWatch), for: .touchUpInside)
    return button
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
    stackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnPoster)))

    return stackView
  }()

  // Setup

  public override func initialize() {
    addSubview(posterImageView)
    addSubview(posterShadowView)

    scrollView.addSubview(contentStackView)

    addSubview(scrollView)
  }

  public override func installConstraints() {
    scrollView.snp.makeConstraints { $0.size.equalToSuperview() }

    contentStackView.snp.makeConstraints {
      $0.width.equalToSuperview()
      $0.top.equalToSuperview()
      $0.bottom.equalToSuperview()
      $0.leading.equalToSuperview()
      $0.trailing.equalToSuperview()
    }

    posterImageView.snp.makeConstraints { $0.size.equalToSuperview() }

    backdropImageView.snp.makeConstraints {
      $0.height.equalTo(scrollView.snp.height).multipliedBy(0.27)
    }

    posterShadowView.snp.makeConstraints { $0.size.equalToSuperview() }
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
