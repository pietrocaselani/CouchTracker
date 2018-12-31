import CouchTrackerCore

final class TrendingCollectionViewDataSource: NSObject, TrendingDataSource, UICollectionViewDataSource {
  var viewModels = [PosterViewModel]()

  private let imageRepository: ImageRepository

  init(imageRepository: ImageRepository) {
    self.imageRepository = imageRepository
  }

  func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
    return viewModels.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let identifier = PosterAndTitleCell.identifier

    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)

    guard let posterCell = cell as? PosterAndTitleCell else {
      Swift.fatalError("cell should be an instance of PosterAndTitleCell")
    }

    let viewModel = viewModels[indexPath.row]
    let interactor = PosterCellService(imageRepository: imageRepository)
    let presenter = PosterCellDefaultPresenter(view: posterCell, interactor: interactor, viewModel: viewModel)

    posterCell.presenter = presenter

    return posterCell
  }
}
