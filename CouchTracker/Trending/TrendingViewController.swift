import UIKit
import RxCocoa
import RxSwift

final class TrendingViewController: UIViewController {
  var appConfigurationsPresentable: AppConfigurationsPresentable!
  var presenter: TrendingPresenter!
  var searchView: SearchView!

  private let disposeBag = DisposeBag()

  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var emptyLabel: UILabel!
  @IBOutlet weak var searchContainer: UIView!
  @IBOutlet weak var trendingTypeSegmentedControl: UISegmentedControl!

  override func awakeFromNib() {
    super.awakeFromNib()

    title = "Trending"
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    guard let searchView = searchView as? UIView else {
      fatalError("searchView should be an instance of UIView")
    }

    guard let collectionViewDataSource = presenter.dataSource as? UICollectionViewDataSource else {
      fatalError("dataSource should be an instance of UICollectionViewDataSource")
    }

    trendingTypeSegmentedControl.setTitle(R.string.localizable.movies(), forSegmentAt: 0)
    trendingTypeSegmentedControl.setTitle(R.string.localizable.shows(), forSegmentAt: 1)

    trendingTypeSegmentedControl.rx.value
      .map { $0 == 0 ? TrendingType.movies : TrendingType.shows }
      .bind(to: presenter.currentTrendingType)
      .disposed(by: disposeBag)

    emptyLabel.text = "No movies to show right now".localized
    collectionView.delegate = self

    searchContainer.addSubview(searchView)

    collectionView.dataSource = collectionViewDataSource

    presenter.viewDidLoad()

    let settingsItem = UIBarButtonItem(image: R.image.settings(), style: .plain, target: nil, action: nil)
    settingsItem.rx.tap.subscribe(onNext: { [unowned self] _ in
      self.appConfigurationsPresentable.showAppSettings()
    }).disposed(by: disposeBag)

    self.navigationItem.rightBarButtonItem = settingsItem
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
