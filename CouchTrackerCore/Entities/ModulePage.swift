public struct ModulePage: Hashable {
    public let page: BaseView
    public let title: String

    public init(page: BaseView, title: String) {
        self.page = page
        self.title = title
    }

    public var hashValue: Int {
        return title.hashValue
    }

    public static func == (lhs: ModulePage, rhs: ModulePage) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
