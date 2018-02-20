import UIKit

final class SearchBarView: UISearchBar, SearchView {
	var presenter: SearchPresenter!

	func showHint(message: String) {
		self.placeholder = message
	}

	override func didMoveToSuperview() {
		super.didMoveToSuperview()

		self.delegate = self

		presenter.viewDidLoad()
	}
}

extension SearchBarView: UISearchBarDelegate {
	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		searchBar.setShowsCancelButton(true, animated: true)
	}

	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		guard let query = searchBar.text else { return }

		presenter.searchMovies(query: query)
	}

	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		searchBar.text = nil
		searchBar.setShowsCancelButton(false, animated: true)
		searchBar.resignFirstResponder()
		presenter.cancelSearch()
	}
}
