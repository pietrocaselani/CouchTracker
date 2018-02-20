enum ShowsManagerOption: String {
	case progress
	case now
	case trending
}

protocol ShowsManagerPresenter: class {
	init(view: ShowsManagerView, moduleSetup: ShowsManagerDataSource)

	func viewDidLoad()
}

protocol ShowsManagerView: class {
	var presenter: ShowsManagerPresenter! { get set }

	func show(pages: [ModulePage], withDefault index: Int)
}

protocol ShowsManagerDataSource: class {
	init(creator: ShowsManagerModuleCreator)

	var options: [ShowsManagerOption] { get }
	var modulePages: [ModulePage] { get }
	var defaultModuleIndex: Int { get }
}

protocol ShowsManagerModuleCreator: class {
	func createModule(for option: ShowsManagerOption) -> BaseView
}
