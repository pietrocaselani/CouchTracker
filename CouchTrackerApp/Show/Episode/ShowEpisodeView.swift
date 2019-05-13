import SnapKit

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

  public let watchButton: LoadingButton = {
    let view = LoadingButton()
    view.button.addTarget(self, action: #selector(didTapOnWatch), for: .touchUpInside)
    return view
  }()

  // Private Views

  private let posterShadowView: UIView = {
    let view = UIView()
    view.backgroundColor = .black
    view.alpha = 0.75
    return view
  }()

  private lazy var contentStackView: ScrollableStackView = {
    let subviews = [previewImageView, titleLabel, overviewLabel,
                    releaseDateLabel, seasonAndNumberLabel, watchedAtLabel, watchButton]
    let view = ScrollableStackView(subviews: subviews)

    let spacing: CGFloat = 20

    view.stackView.axis = .vertical
    view.stackView.alignment = .fill
    view.stackView.spacing = spacing
    view.stackView.distribution = .equalSpacing
    view.stackView.layoutMargins = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    view.stackView.isLayoutMarginsRelativeArrangement = true

    return view
  }()

  // Setup

  public override func initialize() {
    backgroundColor = Colors.View.background

    addSubview(posterImageView)
    addSubview(posterShadowView)

    addSubview(contentStackView)
  }

  public override func installConstraints() {
    contentStackView.snp.makeConstraints { $0.edges.equalToSuperview() }

    posterImageView.snp.makeConstraints { $0.edges.equalToSuperview() }
    posterShadowView.snp.makeConstraints { $0.edges.equalToSuperview() }
    previewImageView.snp.makeConstraints {
      $0.height.equalTo(posterShadowView.snp.height).multipliedBy(0.27)
    }
  }

  @objc private func didTapOnPreview() {
    didTouchOnPreview?()
  }

  @objc private func didTapOnWatch() {
    didTouchOnWatch?()
  }
}
