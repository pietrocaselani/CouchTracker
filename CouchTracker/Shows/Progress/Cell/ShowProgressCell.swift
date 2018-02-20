import UIKit
import Kingfisher

final class ShowProgressCell: UITableViewCell, ShowProgressCellView {
	var presenter: ShowProgressCellPresenter! {
		didSet {
			presenter.viewWillAppear()
		}
	}

	@IBOutlet weak var statusLabel: UILabel!
	@IBOutlet weak var showTitleLabel: UILabel!
	@IBOutlet weak var episodeTitleLabel: UILabel!
	@IBOutlet weak var episodeDateLabel: UILabel!
	@IBOutlet weak var posterImageView: UIImageView!

	func show(viewModel: WatchedShowViewModel) {
		statusLabel.text = viewModel.status
		showTitleLabel.text = viewModel.title
		episodeTitleLabel.text = viewModel.nextEpisode
		episodeDateLabel.text = viewModel.nextEpisodeDate
	}

	func showPosterImage(with url: URL) {
		posterImageView.kf.setImage(with: url, placeholder: R.image.posterListPlaceholder(),
																options: nil, progressBlock: nil, completionHandler: nil)
	}

	override func prepareForReuse() {
		super.prepareForReuse()

		posterImageView.image = nil
		statusLabel.text = nil
		showTitleLabel.text = nil
		episodeTitleLabel.text = nil
		episodeDateLabel.text = nil
	}
}
