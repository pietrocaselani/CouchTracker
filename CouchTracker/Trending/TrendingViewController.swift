import UIKit
import RxCocoa
import RxSwift
import CouchTrackerCore

final class TrendingViewController: UIViewController {
	var presenter: TrendingPresenter!

	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var emptyLabel: UILabel!

	override func awakeFromNib() {
		super.awakeFromNib()

		title = "Trending"
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		guard let collectionViewDataSource = presenter.dataSource as? UICollectionViewDataSource else {
			fatalError("dataSource should be an instance of UICollectionViewDataSource")
		}

		collectionView.register(R.nib.posterCell(), forCellWithReuseIdentifier: R.nib.posterCell.identifier)

		emptyLabel.text = "No movies to show right now".localized

		collectionView.delegate = self
		collectionView.dataSource = collectionViewDataSource

		presenter.viewDidLoad()
	}
}

extension TrendingViewController: TrendingView {
	func showTrendingsView() {
		makeListVisible()
		collectionView.reloadData()
	}

	func showEmptyView() {
		emptyLabel.isHidden = false
		collectionView.isHidden = true
	}

	private func makeListVisible() {
		emptyLabel.isHidden = true
		collectionView.isHidden = false
	}
}

extension TrendingViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		presenter.showDetailsOfTrending(at: indexPath.row)
	}
}
