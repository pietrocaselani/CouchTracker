import CouchTrackerCore
import Kingfisher
import UIKit

final class ShowProgressCell: UITableViewCell, ShowProgressCellView {
    var presenter: ShowProgressCellPresenter! {
        didSet {
            presenter.viewWillAppear()
        }
    }

    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var showTitleLabel: UILabel!
    @IBOutlet var episodeTitleLabel: UILabel!
    @IBOutlet var episodeDateLabel: UILabel!
    @IBOutlet var posterImageView: UIImageView!

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
