import Cartography
import CouchTrackerCore
import Kingfisher

public final class PosterAndTitleCell: CollectionViewCell {
  public static let identifier = "PosterAndTitleCell"

  public var presenter: PosterCellPresenter! {
    didSet {
      presenter.viewWillAppear()
    }
  }

  public let posterImageView = UIImageView()

  public let titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 2
    label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
    label.textColor = .white
    return label
  }()

  private lazy var stackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [posterImageView, titleLabel])

    stackView.axis = .vertical
    stackView.distribution = UIStackView.Distribution.equalSpacing

    return stackView
  }()

  public override func initialize() {
//    labelContainerView.addSubview(titleLabel)

    contentView.addSubview(stackView)

    backgroundColor = Colors.Cell.backgroundColor
  }

  public override func installConstraints() {
    constrain(stackView, posterImageView, titleLabel) { stack, _, label in
      stack.size == stack.superview!.size

      label.height == label.superview!.height * 0.17

//      labelContainer.top == imageView.bottom

//      label.size == label.superview!.size
    }
  }
}

extension PosterAndTitleCell: PosterCellView {
  public func show(viewModel: PosterCellViewModel) {
    titleLabel.text = viewModel.title
  }

  public func showPosterImage(with url: URL) {
    posterImageView.kf.setImage(with: url)
  }
}
