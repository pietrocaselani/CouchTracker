import UIKit
import CouchTrackerCore

final class TrendingCollectionViewDataSource: NSObject, TrendingDataSource, UICollectionViewDataSource {
	var viewModels = [TrendingViewModel]()

	private let imageRepository: ImageRepository

	init(imageRepository: ImageRepository) {
		self.imageRepository = imageRepository
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return viewModels.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let identifier = R.reuseIdentifier.trendingCell

		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) else {
			fatalError("cell isn't an instance of TrendingCell.")
		}

		let viewModel = viewModels[indexPath.row]
		let interactor = TrendingCellService(imageRepository: imageRepository)
		let presenter = TrendingCelliOSPresenter(view: cell, interactor: interactor, viewModel: viewModel)

		cell.presenter = presenter

		return cell
	}
}
