import Foundation

extension String: Localizable {
	public var localized: String {
		return NSLocalizedString(self, comment: "")
	}

	public func localized(_ args: CVarArg...) -> String {
		return withVaList(args) { NSString(format: self.localized, arguments: $0) as String }
	}
}
