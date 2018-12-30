import CouchTrackerCore
import UIKit

final class TrendingCollectionViewDataSource: NSObject, TrendingDataSource, UICollectionViewDataSource {
  var viewModels = [PosterViewModel]()

  private let imageRepository: ImageRepository

  init(imageRepository: ImageRepository) {
    self.imageRepository = imageRepository
  }

  func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
    return viewModels.count
  }

//  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.posterCell, for: indexPath)
//
//    guard let posterCell = cell else {
//      Swift.fatalError("cell should be an instance of PosterCellNew")
//    }
//
//    let viewModel = viewModels[indexPath.row]
//    let interactor = PosterCellService(imageRepository: imageRepository)
//    let presenter = PosterCellDefaultPresenter(view: posterCell, interactor: interactor, viewModel: viewModel)
//
//    posterCell.presenter = presenter
//
//    return posterCell
//  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let identifier = PosterCellNew.identifier

    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)

    guard let posterCell = cell as? PosterCellNew else {
      Swift.fatalError("cell should be an instance of PosterCellNew")
    }

    let viewModel = viewModels[indexPath.row]
    let interactor = PosterCellService(imageRepository: imageRepository)
    let presenter = PosterCellDefaultPresenter(view: posterCell, interactor: interactor, viewModel: viewModel)

    posterCell.presenter = presenter

    return posterCell
  }
}
