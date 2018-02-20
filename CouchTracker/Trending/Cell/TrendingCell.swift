import UIKit
import Kingfisher
import RxSwift

final class TrendingCell: UICollectionViewCell, TrendingCellView {
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var coverImageView: UIImageView!

	var presenter: TrendingCellPresenter! {
		didSet {
			presenter.viewWillAppear()
		}
	}

	func show(viewModel: TrendingCellViewModel) {
		titleLabel.text = viewModel.title
	}

	func showPosterImage(with url: URL) {
		coverImageView.kf.setImage(with: url, placeholder: R.image.posterPlacehoder(),
															options: nil, progressBlock: nil, completionHandler: nil)
	}

	override func prepareForReuse() {
		super.prepareForReuse()

		coverImageView.image = nil
		titleLabel.text = nil
	}
}
