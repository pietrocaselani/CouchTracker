import CouchTrackerCore
import Kingfisher
import RxSwift
import SnapKit

final class ShowProgressCell: TableViewCell {
  static let identifier = "ShowProgressCell"
  private var imageTask: DownloadTask?
  private var disposable: Disposable?

  var presenter: ShowProgressCellPresenter? {
    didSet {
      disposable = presenter?.observeViewState().subscribe(onNext: { [weak self] viewState in
        self?.handleViewState(viewState)
      })

      presenter?.viewWillAppear()
    }
  }

  override func prepareForReuse() {
    imageTask?.cancel()
    posterImageView.image = nil
    disposable = nil

    super.prepareForReuse()
  }

  private func handleViewState(_ viewState: ShowProgressCellViewState) {
    switch viewState {
    case let .viewModel(viewModel):
      show(viewModel: viewModel)
    case let .viewModelAndPosterURL(viewModel, url):
      show(viewModel: viewModel)
      showPosterImage(with: url)
    }
  }

  private func show(viewModel: WatchedShowViewModel) {
    showTitleLabel.text = viewModel.title
    episodeTitleLabel.text = viewModel.nextEpisode
    statusAndDateLabel.text = viewModel.nextEpisodeDate
    remainingAndNetworkLabel.text = viewModel.status
  }

  private func showPosterImage(with url: URL) {
    imageTask = posterImageView.kf.setImage(with: url)
  }

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
    let margin: CGFloat = 5

    posterImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(margin)
      $0.bottom.equalToSuperview().inset(margin)
      $0.left.equalToSuperview().offset(margin)
      $0.width.equalTo(posterImageView.snp.height).multipliedBy(0.75)
    }

    labelsStackView.snp.makeConstraints {
      $0.left.equalTo(posterImageView.snp.right).offset(margin)
      $0.top.equalTo(posterImageView.snp.top)
      $0.bottom.equalTo(posterImageView.snp.bottom)
      $0.right.equalToSuperview()
    }
  }
}
