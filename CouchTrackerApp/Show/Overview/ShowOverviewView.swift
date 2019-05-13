import SnapKit

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

    let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOnBackdrop))
    tap.numberOfTapsRequired = 1

    imageView.addGestureRecognizer(tap)
    imageView.isUserInteractionEnabled = true
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

  private let posterShadowView: UIView = {
    let view = UIView()
    view.backgroundColor = .black
    view.alpha = 0.75
    return view
  }()

  private lazy var contentStackView: ScrollableStackView = {
    let subviews = [backdropImageView, titleLabel, statusLabel, networkLabel,
                    overviewLabel, genresLabel, releaseDateLabel]
    let view = ScrollableStackView(subviews: subviews)

    let spacing: CGFloat = 20

    view.stackView.axis = .vertical
    view.stackView.alignment = .fill
    view.stackView.spacing = spacing
    view.stackView.distribution = .equalSpacing
    view.stackView.layoutMargins = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    view.stackView.isLayoutMarginsRelativeArrangement = true
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnPoster)))
    view.stackView.isUserInteractionEnabled = false

    return view
  }()

  // Setup

  public override func initialize() {
    addSubview(posterImageView)
    addSubview(posterShadowView)

    addSubview(contentStackView)
  }

  public override func installConstraints() {
    contentStackView.snp.makeConstraints { $0.edges.equalToSuperview() }

    posterImageView.snp.makeConstraints { $0.edges.equalToSuperview() }
    posterShadowView.snp.makeConstraints { $0.edges.equalToSuperview() }
    backdropImageView.snp.makeConstraints {
      $0.height.equalTo(posterShadowView.snp.height).multipliedBy(0.27)
    }
  }

  @objc private func didTapOnPoster() {
    didTouchOnPoster?()
  }

  @objc private func didTapOnBackdrop() {
    didTouchOnBackdrop?()
  }
}
