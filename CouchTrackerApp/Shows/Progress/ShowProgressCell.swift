import Cartography
import CouchTrackerCore

final class ShowProgressCell: TableViewCell, ShowProgressCellView {
  static let identifier = "ShowProgressCell"
  // Remove
  var presenter: ShowProgressCellPresenter! {
    didSet {
      posterImageView.image = nil
      presenter.viewWillAppear()
    }
  }

  func show(viewModel: WatchedShowViewModel) {
    showTitleLabel.text = viewModel.title
    episodeTitleLabel.text = viewModel.nextEpisode
    statusAndDateLabel.text = viewModel.nextEpisodeDate
    remainingAndNetworkLabel.text = viewModel.status
  }

  func showPosterImage(with url: URL) {
    posterImageView.kf.setImage(with: url)
  }

  // Remove

  let posterImageView = UIImageView()

  let showTitleLabel: UILabel = {
    let label = UILabel()
    label.textColor = Colors.Text.primaryTextColor
    label.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    return label
  }()

  let episodeTitleLabel: UILabel = {
    let label = UILabel()
    label.textColor = Colors.Text.primaryTextColor
    label.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    return label
  }()

  let remainingAndNetworkLabel: UILabel = {
    let label = UILabel()
    label.textColor = Colors.Text.secondaryTextColor
    label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
    return label
  }()

  let statusAndDateLabel: UILabel = {
    let label = UILabel()
    label.textColor = Colors.Text.secondaryTextColor
    label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
    return label
  }()

  private lazy var labelsStackView: UIStackView = {
    let subviews = [remainingAndNetworkLabel, showTitleLabel, episodeTitleLabel, statusAndDateLabel]
    let stack = UIStackView(arrangedSubviews: subviews)
    stack.axis = .vertical
    stack.distribution = .fillProportionally
    return stack
  }()

  override func initialize() {
    addSubview(labelsStackView)
    addSubview(posterImageView)
    backgroundColor = Colors.Cell.backgroundColor
  }

  override func installConstraints() {
    constrain(labelsStackView, posterImageView) { stack, poster in
      let margin: CGFloat = 5

      poster.height == poster.superview!.height - (margin * 2)
      poster.width == poster.height * 0.75
      poster.left == poster.superview!.left + margin
      poster.top == poster.superview!.top + margin
      poster.bottom == poster.superview!.bottom - margin

      stack.left == poster.right + margin
      stack.top == poster.top
      stack.bottom == poster.bottom
      stack.right == stack.superview!.right
    }
  }
}
