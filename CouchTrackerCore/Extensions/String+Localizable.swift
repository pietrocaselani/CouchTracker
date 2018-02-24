import Foundation

extension String: Localizable {
	public var bundle: Bundle {
		return BundleProvider.provide
	}

	public var localized: String {
		return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
	}

	public func localized(_ args: CVarArg...) -> String {
		let realString = localized
		return withVaList(args) { NSString(format: realString, arguments: $0) as String }
	}
}
