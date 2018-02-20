final class ShowsManagerViewMock: ShowsManagerView {
	var presenter: ShowsManagerPresenter!
	var showNeedsTraktLoginInvoked = false
	var showPagesInvoked = false
	var showPagesParameters: (pages: [ModulePage], index: Int)? = nil

	func show(pages: [ModulePage], withDefault index: Int) {
		showPagesInvoked = true
		showPagesParameters = (pages, index)
	}
}

final class ShowsManagerDataSourceMock: ShowsManagerDataSource {
	var options: [ShowsManagerOption]
	var modulePages: [ModulePage]
	var defaultModuleIndex: Int

	init(creator: ShowsManagerModuleCreator) {
		options = [.progress, .now, .trending]
		modulePages = [ModulePage]()
		defaultModuleIndex = 0
	}

	init(options: [ShowsManagerOption] = [.progress, .now, .trending], modulePages: [ModulePage], index: Int = 0) {
		self.options = options
		self.modulePages = modulePages
		self.defaultModuleIndex = index
	}
}

final class ShowsManagerCreatorMock: ShowsManagerModuleCreator {
	func createModule(for option: ShowsManagerOption) -> BaseView {
		return BaseViewMock()
	}
}
