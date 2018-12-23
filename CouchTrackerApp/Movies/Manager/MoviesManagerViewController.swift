import CouchTrackerCore
import Pageboy
import Tabman

final class MoviesManagerViewController: TabmanViewController, MoviesManagerView, TMBarCouchTracker {
  var presenter: MoviesManagerPresenter!
  private var pages = [ModulePage]()
  private var defaultPageIndex = 0

  override func awakeFromNib() {
    super.awakeFromNib()

    title = R.string.localizable.movies()
    navigationItem.title = nil
    dataSource = self
    delegate = self

    // CT-TODO fix this
    let bar = defaultCTBar()

    addBar(bar, dataSource: self, at: .top)

//    bar.defaultCTAppearance()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    guard presenter != nil else {
      fatalError("MoviesManagerViewController was loaded without a presenter")
    }

    presenter.viewDidLoad()
  }

  func show(pages: [ModulePage], withDefault index: Int) {
    self.pages = pages
    defaultPageIndex = index

    reloadData()
  }

  override func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollToPageAt index: Int,
                                      direction: PageboyViewController.NavigationDirection, animated: Bool) {
    super.pageboyViewController(pageboyViewController, didScrollToPageAt: index,
                                direction: direction, animated: animated)

    let currentViewController = viewController(for: pageboyViewController, at: index)

    navigationItem.leftBarButtonItems = currentViewController?.navigationItem.leftBarButtonItems
    navigationItem.rightBarButtonItems = currentViewController?.navigationItem.rightBarButtonItems
  }
}

extension MoviesManagerViewController: TMBarDataSource {
  func barItem(for _: TMBar, at index: Int) -> TMBarItemable {
    return TMBarItem(title: pages[index].title)
  }
}

extension MoviesManagerViewController: PageboyViewControllerDataSource {
  func numberOfViewControllers(in _: PageboyViewController) -> Int {
    return pages.count
  }

  func viewController(for _: PageboyViewController,
                      at index: PageboyViewController.PageIndex) -> UIViewController? {
    return pages[index].page as? UIViewController
  }

  func defaultPage(for _: PageboyViewController) -> PageboyViewController.Page? {
    return Page.at(index: defaultPageIndex)
  }
}
