public protocol Localizable {
	var localized: String { get }
	func localized(_ args: CVarArg...) -> String
}
