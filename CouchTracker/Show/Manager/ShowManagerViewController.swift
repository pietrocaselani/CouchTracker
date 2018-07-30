import CouchTrackerCore
import Pageboy
import Tabman
import UIKit

final class ShowManagerViewController: TabmanViewController, ShowManagerView {
    var presenter: ShowManagerPresenter!
    private var moduleViews: [BaseView]?
    private var defaultPageIndex = 0

    override func awakeFromNib() {
        super.awakeFromNib()

        dataSource = self
        delegate = self
        bar.defaultCTAppearance()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard presenter != nil else {
            fatalError("View loaded without a prenseter")
        }

        presenter.viewDidLoad()
    }

    func show(pages: [ModulePage], withDefault index: Int) {
        moduleViews = pages.map { $0.page }
        defaultPageIndex = index
        bar.items = pages.map { Item(title: $0.title) }

        reloadPages()
    }

    override func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollToPageAt index: Int,
                                        direction: PageboyViewController.NavigationDirection, animated: Bool) {
        super.pageboyViewController(pageboyViewController, didScrollToPageAt: index,
                                    direction: direction, animated: animated)

        presenter.selectTab(index: index)
    }
}

extension ShowManagerViewController: PageboyViewControllerDataSource {
    func numberOfViewControllers(in _: PageboyViewController) -> Int {
        return moduleViews?.count ?? 0
    }

    func viewController(for _: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return moduleViews?[index] as? UIViewController
    }

    func defaultPage(for _: PageboyViewController) -> PageboyViewController.Page? {
        return Page.at(index: defaultPageIndex)
    }
}
