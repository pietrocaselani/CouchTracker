public enum MoviesManagerOption: String {
	case trending
}

public protocol MoviesManagerPresenter: class {
	init(view: MoviesManagerView, dataSource: MoviesManagerDataSource)

	func viewDidLoad()
}

public protocol MoviesManagerView: class {
	var presenter: MoviesManagerPresenter! { get set }

	func show(pages: [ModulePage], withDefault index: Int)
}

public protocol MoviesManagerDataSource: class {
	var options: [MoviesManagerOption] { get }

	func modulePages() -> [ModulePage]
	func defaultModuleIndex() -> Int
}
