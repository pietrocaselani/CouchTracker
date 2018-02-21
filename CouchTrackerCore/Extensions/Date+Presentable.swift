import Foundation

extension Date {
	func shortString() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "short date format".localized
		return dateFormatter.string(from: self)
	}
}
