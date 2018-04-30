public enum ShowsManagerOption: String {
	case progress
	case now
	case trending
	case search
}

public protocol ShowsManagerPresenter: class {
	init(view: ShowsManagerView, moduleSetup: ShowsManagerDataSource)

	func viewDidLoad()
	func selectTab(index: Int)
}

public protocol ShowsManagerView: class {
	var presenter: ShowsManagerPresenter! { get set }

	func show(pages: [ModulePage], withDefault index: Int)
}

public protocol ShowsManagerDataSource: class {
	init(creator: ShowsManagerModuleCreator)

	var options: [ShowsManagerOption] { get }
	var modulePages: [ModulePage] { get }
	var defaultModuleIndex: Int { get set }
}

public protocol ShowsManagerModuleCreator: class {
	func createModule(for option: ShowsManagerOption) -> BaseView
}
