import CouchTrackerCore
import Pageboy
import Tabman
import UIKit

final class ShowsManagerViewController: TabmanViewController, ShowsManagerView, TMBarCouchTracker {
  var presenter: ShowsManagerPresenter!
  private var pages = [ModulePage]()
  private var defaultPageIndex = 0

  override func awakeFromNib() {
    super.awakeFromNib()

    title = R.string.localizable.shows()
    navigationItem.title = nil
    dataSource = self
    delegate = self

    let bar = defaultCTBar()
    addBar(bar, dataSource: self, at: .top)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    guard presenter != nil else {
      fatalError("ShowsManagerViewController was loaded without a presenter")
    }

    view.backgroundColor = Colors.View.background

    presenter.viewDidLoad()
  }

  func show(pages: [ModulePage], withDefault index: Int) {
    self.pages = pages
    defaultPageIndex = index

    reloadData()
  }

  func showNeedsTraktLogin() {
    let message = "You need to log in on Trakt to use this screen"
    let alert = UIAlertController(title: "Trakt", message: message, preferredStyle: .alert)

    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
      alert.dismiss(animated: true, completion: nil)
    }))

    present(alert, animated: true, completion: nil)
  }

  override func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollToPageAt index: Int,
                                      direction: PageboyViewController.NavigationDirection, animated: Bool) {
    super.pageboyViewController(pageboyViewController, didScrollToPageAt: index,
                                direction: direction, animated: animated)

    let currentViewController = viewController(for: pageboyViewController, at: index)

    navigationItem.leftBarButtonItems = currentViewController?.navigationItem.leftBarButtonItems
    navigationItem.rightBarButtonItems = currentViewController?.navigationItem.rightBarButtonItems

    presenter.selectTab(index: index)
  }
}

extension ShowsManagerViewController: TMBarDataSource {
  func barItem(for _: TMBar, at index: Int) -> TMBarItemable {
    return TMBarItem(title: pages[index].title)
  }
}

extension ShowsManagerViewController: PageboyViewControllerDataSource {
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
