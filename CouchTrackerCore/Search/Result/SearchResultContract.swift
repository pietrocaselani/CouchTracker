import TraktSwift

public protocol SearchResultView: class {
	var presenter: SearchResultPresenter! { get set }

	func show(viewModels: [PosterViewModel])
	func showSearching()
	func showNotSearching()
	func showEmptyResults()
	func showError(message: String)
}

public protocol SearchResultRouter: class {
	func showDetails(of result: SearchResult)
}

public protocol SearchResultPresenter: class {
	init(view: SearchResultView, router: SearchResultRouter)

	func selectResult(at index: Int)
}
