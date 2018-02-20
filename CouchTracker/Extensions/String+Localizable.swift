import Foundation

extension String: Localizable {
	var localized: String {
		return NSLocalizedString(self, comment: "")
	}

	func localized(_ args: CVarArg...) -> String {
		return withVaList(args) { NSString(format: self.localized, arguments: $0) as String }
	}
}
