public enum ShowManagerOption: String {
	case overview
	case episode
	case seasons
}

public protocol ShowManagerPresenter: class {
	init(view: ShowManagerView, dataSource: ShowManagerDataSource)

	func viewDidLoad()
	func selectTab(index: Int)
}

public protocol ShowManagerModuleCreator: class {
	func createModule(for option: ShowManagerOption) -> BaseView
}

public protocol ShowManagerDataSource: class {
	init(show: WatchedShowEntity, creator: ShowManagerModuleCreator)

	var showTitle: String? { get }
	var options: [ShowManagerOption] { get }
	var modulePages: [ModulePage] { get }
	var defaultModuleIndex: Int { get set }
}

public protocol ShowManagerView: class {
	var presenter: ShowManagerPresenter! { get set }
	var title: String? { get set }

	func show(pages: [ModulePage], withDefault index: Int)
}
