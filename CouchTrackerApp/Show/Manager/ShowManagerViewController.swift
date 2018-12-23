import CouchTrackerCore
import Pageboy
import Tabman
import UIKit

final class ShowManagerViewController: TabmanViewController, ShowManagerView {
  var presenter: ShowManagerPresenter!
  private var pages = [ModulePage]()
  private var defaultPageIndex = 0

  override func awakeFromNib() {
    super.awakeFromNib()

    dataSource = self
    delegate = self

    // CT-TODO fix this
    let bar = TMBar.ButtonBar()
    addBar(bar, dataSource: self, at: .top)

//    bar.defaultCTAppearance()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    guard presenter != nil else {
      fatalError("View loaded without a prenseter")
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

    presenter.selectTab(index: index)
  }
}

extension ShowManagerViewController: TMBarDataSource {
  func barItem(for _: TMBar, at index: Int) -> TMBarItemable {
    return TMBarItem(title: pages[index].title)
  }
}

extension ShowManagerViewController: PageboyViewControllerDataSource {
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
