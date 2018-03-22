public enum MoviesManagerOption: String {
	case trending
	case search
}

public protocol MoviesManagerPresenter: class {
	init(view: MoviesManagerView, dataSource: MoviesManagerDataSource)

	func viewDidLoad()
}

public protocol MoviesManagerView: class {
	var presenter: MoviesManagerPresenter! { get set }

	func show(pages: [ModulePage], withDefault index: Int)
}

public protocol MoviesManagerModuleCreator: class {
	func createModule(for option: MoviesManagerOption) -> BaseView
}

public protocol MoviesManagerDataSource: class {
	var options: [MoviesManagerOption] { get }
	var modulePages: [ModulePage] { get }
	var defaultModuleIndex: Int { get }

	init(creator: MoviesManagerModuleCreator)
}
