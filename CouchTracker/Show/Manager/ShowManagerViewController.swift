import UIKit
import Tabman
import Pageboy

final class ShowManagerViewController: TabmanViewController, ShowManagerView {
	var presenter: ShowManagerPresenter!
	private var moduleViews: [BaseView]?
	private var defaultPageIndex = 0

	override func awakeFromNib() {
		super.awakeFromNib()

		self.dataSource = self
		self.delegate = self
		self.bar.defaultCTAppearance()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		guard presenter != nil else {
			fatalError("View loaded without a prenseter")
		}

		presenter.viewDidLoad()
	}

	func show(pages: [ModulePage], withDefault index: Int) {
		self.moduleViews = pages.map { $0.page }
		self.defaultPageIndex = index
		self.bar.items = pages.map { Item(title: $0.title) }

		self.reloadPages()
	}
}

extension ShowManagerViewController: PageboyViewControllerDataSource {

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
