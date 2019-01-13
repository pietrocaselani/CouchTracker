import Cartography
import CouchTrackerCore
import Kingfisher

public final class PosterAndTitleCell: CollectionViewCell {
  public static let identifier = "PosterAndTitleCell"
  private var imageTask: DownloadTask?

  public var presenter: PosterCellPresenter! {
    didSet {
      imageTask?.cancel()
      posterImageView.image = nil
      presenter.viewWillAppear()
    }
  }

  public override func prepareForReuse() {
    imageTask?.cancel()
    posterImageView.image = nil
    super.prepareForReuse()
  }

  public let posterImageView = UIImageView()

  public let titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 2
    label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
    label.textColor = Colors.Text.primaryTextColor
    return label
  }()

  private lazy var stackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [posterImageView, titleLabel])

    stackView.axis = .vertical
    stackView.distribution = UIStackView.Distribution.equalSpacing

    return stackView
  }()

  public override func initialize() {
    contentView.addSubview(stackView)

    backgroundColor = Colors.Cell.foregroundColor
  }

  public override func installConstraints() {
    constrain(stackView, posterImageView, titleLabel) { stack, _, label in
      stack.size == stack.superview!.size

      label.height == label.superview!.height * 0.17
    }
  }
}

extension PosterAndTitleCell: PosterCellView {
  public func show(viewModel: PosterCellViewModel) {
    titleLabel.text = viewModel.title
  }

  public func showPosterImage(with url: URL) {
    imageTask = posterImageView.kf.setImage(with: url)
  }
}
