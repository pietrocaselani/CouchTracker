@testable import CouchTrackerCore

final class ModulePageMocks {
	static func createPages(count: Int) -> [ModulePage] {
		return (0..<count).map { index -> ModulePage in
			let title = "Page\(index)"
			let view = BaseViewMock(title: title)
			return ModulePage(page: view, title: title)
		}
	}
}
