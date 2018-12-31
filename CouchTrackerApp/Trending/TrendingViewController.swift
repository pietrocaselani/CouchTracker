import CouchTrackerCore
import RxCocoa
import RxSwift

public final class TrendingViewController: UIViewController {
  public var presenter: TrendingPresenter!
  public var trendingType: TrendingType = .movies

  private var trendingView: TrendingView {
    guard let trendingView = self.view as? TrendingView else {
      preconditionFailure("self.view should be an instance of TrendingView")
    }
    return trendingView
  }

  init() {
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder _: NSCoder) {
    Swift.fatalError("init(coder:) has not been implemented")
  }

  public override func loadView() {
    let cellSize = ViewCalculations.posterAndTitleCellSize()

    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.itemSize = cellSize
    layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    layout.minimumInteritemSpacing = 5
    layout.minimumLineSpacing = 5

    view = TrendingView(collectionViewLayout: layout)
  }

  public override func viewDidLoad() {
    super.viewDidLoad()

    guard presenter != nil else {
      fatalError("view initialized without a presenter!")
    }

    guard let collectionViewDataSource = presenter.dataSource as? UICollectionViewDataSource else {
      fatalError("dataSource should be an instance of UICollectionViewDataSource")
    }

    trendingView.backgroundColor = Colors.View.background
    trendingView.collectionView.backgroundColor = Colors.View.background

    let emptyText: String

    if trendingType == .movies {
      emptyText = R.string.localizable.noMoviesToShowRightNow()
    } else {
      emptyText = R.string.localizable.noTvShowsToShowRightNow()
    }

    trendingView.emptyView.label.text = emptyText
    trendingView.collectionView.register(PosterAndTitleCell.self,
                                         forCellWithReuseIdentifier: PosterAndTitleCell.identifier)

    trendingView.collectionView.dataSource = collectionViewDataSource
    trendingView.collectionView.delegate = self

    presenter.viewDidLoad()
  }
}

extension TrendingViewController: UICollectionViewDelegate {
  public func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    presenter.showDetailsOfTrending(at: indexPath.row)
  }
}

extension TrendingViewController: TrendingViewProtocol {
  public func showTrendingsView() {
    makeListVisible()
    trendingView.collectionView.reloadData()
  }

  public func showEmptyView() {
    trendingView.collectionView.isHidden = true
    trendingView.emptyView.isHidden = false
  }

  private func makeListVisible() {
    trendingView.collectionView.isHidden = false
    trendingView.emptyView.isHidden = true
  }
}
