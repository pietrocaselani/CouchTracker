import UIKit
import CouchTrackerCore

final class TrendingCollectionViewDataSource: NSObject, TrendingDataSource, UICollectionViewDataSource {
	var viewModels = [PosterViewModel]()

	private let imageRepository: ImageRepository

	init(imageRepository: ImageRepository) {
		self.imageRepository = imageRepository
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return viewModels.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let identifier = R.reuseIdentifier.posterCell

		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) else {
			Swift.fatalError("Poster cell should not be nil")
		}

		let viewModel = viewModels[indexPath.row]
		let interactor = PosterCellService(imageRepository: imageRepository)
		let presenter = PosterCellDefaultPresenter(view: cell, interactor: interactor, viewModel: viewModel)

		cell.presenter = presenter

		return cell
	}
}
