import CouchTrackerCore

final class SearchCollectionViewDataSource: NSObject, SearchDataSource {
  private let interactor: PosterCellInteractor

  var entities = [SearchResultEntity]()

  init(interactor: PosterCellInteractor) {
    self.interactor = interactor
  }

  func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
    return entities.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let identifier = PosterAndTitleCell.identifier

    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)

    guard let posterCell = cell as? PosterAndTitleCell else {
      Swift.fatalError("cell should be an instance of PosterAndTitleCell")
    }

    let entity = entities[indexPath.row]
    let viewModel = mapEntityToViewModel(entity)

    let presenter = PosterCellDefaultPresenter(view: posterCell, interactor: interactor, viewModel: viewModel)

    posterCell.presenter = presenter

    return posterCell
  }
}

private func mapEntityToViewModel(_ entity: SearchResultEntity) -> PosterViewModel {
  switch entity.type {
  case let .movie(movie):
    let type = movie.ids.tmdb.map { PosterViewModelType.movie(tmdbMovieId: $0) }
    return PosterViewModel(title: movie.title ?? "", type: type)
  case let .show(show):
    let type = show.ids.tmdb.map { PosterViewModelType.show(tmdbShowId: $0) }
    return PosterViewModel(title: show.title ?? "", type: type)
  }
}
