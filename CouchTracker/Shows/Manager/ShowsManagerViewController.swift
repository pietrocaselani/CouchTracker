import UIKit
import RxCocoa
import RxSwift
import Tabman
import Pageboy

final class ShowsManagerViewController: TabmanViewController, ShowsManagerView {
  var presenter: ShowsManagerPresenter!
  private let disposeBag = DisposeBag()
  private var moduleViews: [BaseView]?
  private var defaultPageIndex = 0

  override func awakeFromNib() {
    super.awakeFromNib()

    self.title = R.string.localizable.shows()
    self.dataSource = self
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    guard presenter != nil else {
      fatalError("ShowsManagerViewController was loaded without a presenter")
    }

    self.bar.defaultCTAppearance()

    presenter.viewDidLoad()
  }

  func show(pages: [ShowManagerModulePage], withDefault index: Int) {
    moduleViews = pages.map { $0.page }
    defaultPageIndex = index

    self.bar.items = pages.map { Item(title: $0.title) }

    self.reloadPages()
  }

  func showNeedsTraktLogin() {
    print("Please, Login on Trakt.tv")
  }
}

extension ShowsManagerViewController: PageboyViewControllerDataSource {
  func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
    return moduleViews?.count ?? 0
  }

  func viewController(for pageboyViewController: PageboyViewController,
                      at index: PageboyViewController.PageIndex) -> UIViewController? {
    return moduleViews?[index] as? UIViewController
  }

  func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
    return Page.at(index: defaultPageIndex)
  }
}
