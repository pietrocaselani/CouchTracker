import CouchTrackerCore
import Pageboy
import RxSwift
import Tabman

final class ShowsManagerViewController: TabmanViewController, TMBarCouchTracker {
  private typealias Strings = CouchTrackerCoreStrings
  private let presenter: ShowsManagerPresenter
  private let disposeBag = DisposeBag()
  private var pages = [ModulePage]()
  private var defaultPageIndex = 0

  init(presenter: ShowsManagerPresenter) {
    self.presenter = presenter
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    title = Strings.shows()
    navigationItem.title = nil
    dataSource = self
    delegate = self

    let bar = defaultCTBar()
    addBar(bar, dataSource: self, at: .top)

    view.backgroundColor = Colors.View.background

    presenter.observeViewState().subscribe(onNext: { [weak self] viewState in
      self?.handleViewState(viewState)
    }).disposed(by: disposeBag)

    presenter.viewDidLoad()
  }

  private func handleViewState(_ viewState: ShowsManagerViewState) {
    switch viewState {
    case let .showing(pages, selectedIndex):
      show(pages: pages, withDefault: selectedIndex)
    default: break
    }
  }

  private func show(pages: [ModulePage], withDefault index: Int) {
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
