import CouchTrackerCore

final class SearchCollectionViewDataSource: NSObject, UICollectionViewDataSource {
  private let interactor: PosterCellInteractor

  var viewModels = [PosterViewModel]()

  init(interactor: PosterCellInteractor) {
    self.interactor = interactor
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
    let presenter = PosterCellDefaultPresenter(view: posterCell, interactor: interactor, viewModel: viewModel)

    posterCell.presenter = presenter

    return posterCell
  }
}
