import UIKit
import Tabman
import Pageboy

final class ShowsManagerViewController: TabmanViewController, ShowsManagerView {
	var presenter: ShowsManagerPresenter!
	private var moduleViews: [BaseView]?
	private var defaultPageIndex = 0

	override func awakeFromNib() {
		super.awakeFromNib()

		self.title = R.string.localizable.shows()
		self.navigationItem.title = nil
		self.dataSource = self
		self.delegate = self
		self.bar.defaultCTAppearance()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		guard presenter != nil else {
			fatalError("ShowsManagerViewController was loaded without a presenter")
		}

		presenter.viewDidLoad()
	}

	func show(pages: [ModulePage], withDefault index: Int) {
		moduleViews = pages.map { $0.page }
		defaultPageIndex = index

		self.bar.items = pages.map { Item(title: $0.title) }

		self.reloadPages()
	}

	func showNeedsTraktLogin() {
		let message = "You need to log in on Trakt to use this screen"
		let alert = UIAlertController(title: "Trakt", message: message, preferredStyle: .alert)

		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
			alert.dismiss(animated: true, completion: nil)
		}))

		self.present(alert, animated: true, completion: nil)
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
