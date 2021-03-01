import UIKit
import Combine
import ComposableArchitecture

private extension UICollectionViewLayout {
  static func trendingMovies() -> UICollectionViewLayout {
    let cellSize = posterAndTitleCellSize()

    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.itemSize = cellSize
    layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    layout.minimumInteritemSpacing = 5
    layout.minimumLineSpacing = 5

    return layout
  }
}

final class TrendingMoviesViewController: UIViewController {
  private let trendingView = TrendingView(collectionViewLayout: .trendingMovies())
  private let store: ViewStore<TrendingMoviesState, TrendingMoviesAction>
  private let dataSource = TrendingMovieDataSource()
  private var cancellables = Set<AnyCancellable>()

  init(store: Store<TrendingMoviesState, TrendingMoviesAction>) {
    self.store = ViewStore(store)
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    view = trendingView
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    trendingView.collectionView.prefetchDataSource = self

    trendingView.collectionView.register(
      TrendingMovieCell.self,
      forCellWithReuseIdentifier: TrendingMovieCell.cellIdentifier
    )

    store.publisher.trendingMovies.sink { [weak self] trendingMovies in
      self?.appendNewMovies(trendingMovies)
    }.store(in: &cancellables)

    store.send(.requestNextPage)
  }

  private func appendNewMovies(_ movies: [TrendingMovieEntity]) {
    trendingView.collectionView.performBatchUpdates({
      dataSource.append(movies: movies)
      trendingView.collectionView.reloadData()
    }, completion: nil)

  }
}

extension TrendingMoviesViewController: UICollectionViewDataSourcePrefetching {
  func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
    print(">>> Fetching index paths = \(indexPaths)")
    store.send(.requestNextPage)
  }
}

final class TrendingMovieDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
  private var movies = [TrendingMovieEntity]()

  func append(movies: [TrendingMovieEntity]) {
    self.movies.append(contentsOf: movies)
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    movies.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: TrendingMovieCell.cellIdentifier,
      for: indexPath
    )

    guard let posterCell = cell as? TrendingMovieCell else {
      fatalError("Cell is not registred")
    }

    let movie = movies[indexPath.row].movie

    posterCell.apply(
      viewModel: .init(title: movie.title ?? "TBA",
                       imageURL: .init(fileURLWithPath: "/")
      )
    )

    return posterCell
  }
}
