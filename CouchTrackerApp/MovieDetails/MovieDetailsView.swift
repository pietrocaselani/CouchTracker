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
    label.font = Fonts.titleBold
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

  public let genresLabel = TitleDetailLabels()

  public let releaseDateLabel = TitleDetailLabels()

  public let watchedAtLabel = TitleDetailLabels()

  public let watchButton: LoadingButton = {
    let button = LoadingButton()
    button.button.addTarget(self, action: #selector(didTapOnWatch), for: .touchUpInside)
    return button
  }()

  // Private Views
  private let posterShadowView: UIView = {
    let view = UIView()
    view.backgroundColor = .black
    view.alpha = 0.75
    return view
  }()

  private lazy var contentStackView: ScrollableStackView = {
    let subviews = [backdropImageView, titleLabel, taglineLabel, overviewLabel,
                    genresLabel, releaseDateLabel, watchedAtLabel, watchButton]
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
    contentStackView.snp.makeConstraints { $0.size.equalToSuperview() }
    posterImageView.snp.makeConstraints { $0.size.equalToSuperview() }
    backdropImageView.snp.makeConstraints {
      $0.height.equalTo(self.snp.height).multipliedBy(0.27)
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
