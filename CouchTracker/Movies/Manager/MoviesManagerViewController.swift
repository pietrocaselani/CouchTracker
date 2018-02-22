import Tabman
import Pageboy
import CouchTrackerCore

final class MoviesManagerViewController: TabmanViewController, MoviesManagerView {
	var presenter: MoviesManagerPresenter!
	private var moduleViews: [BaseView]?
	private var defaultPageIndex = 0

	override func awakeFromNib() {
		super.awakeFromNib()

		self.title = R.string.localizable.movies()
		self.navigationItem.title = nil
		self.dataSource = self
		self.delegate = self
		self.bar.defaultCTAppearance()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		guard presenter != nil else {
			fatalError("MoviesManagerViewController was loaded without a presenter")
		}

		presenter.viewDidLoad()
	}

	func show(pages: [ModulePage], withDefault index: Int) {
		moduleViews = pages.map { $0.page }
		defaultPageIndex = index

		self.bar.items = pages.map { Item(title: $0.title) }

		self.reloadPages()
	}

	override func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollToPageAt index: Int,
																																					direction: PageboyViewController.NavigationDirection, animated: Bool) {
		super.pageboyViewController(pageboyViewController, didScrollToPageAt: index,
																														direction: direction, animated: animated)

		let currentViewController = self.viewController(for: pageboyViewController, at: index)

		self.navigationItem.leftBarButtonItems = currentViewController?.navigationItem.leftBarButtonItems
		self.navigationItem.rightBarButtonItems = currentViewController?.navigationItem.rightBarButtonItems
	}
}

extension MoviesManagerViewController: PageboyViewControllerDataSource {
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
