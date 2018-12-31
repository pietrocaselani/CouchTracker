import CouchTrackerCore
import Pageboy
import RxSwift
import Tabman

final class ShowManagerViewController: TabmanViewController, TMBarCouchTracker {
  private let disposeBag = DisposeBag()
  var presenter: ShowManagerPresenter!
  private var pages = [ModulePage]()
  private var defaultPageIndex = 0

  init(presenter: ShowManagerPresenter) {
    self.presenter = presenter
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    dataSource = self
    delegate = self

    let bar = defaultCTBar()
    addBar(bar, dataSource: self, at: .top)

    view.backgroundColor = Colors.View.background

    presenter.observeViewState()
      .subscribe(onNext: { [weak self] viewState in
        self?.handleViewState(viewState)
      }).disposed(by: disposeBag)

    presenter.viewDidLoad()
  }

  private func handleViewState(_ viewState: ShowManagerViewState) {
    switch viewState {
    case let .showing(title, pages, index):
      show(title: title, pages: pages, withDefault: index)
    default: break
    }
  }

  private func show(title: String?, pages: [ModulePage], withDefault index: Int) {
    self.title = title
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
