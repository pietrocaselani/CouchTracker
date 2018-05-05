import Foundation

extension Date {
	func shortString() -> String {
		let dateFormatter = DateFormatter()
		let format = "short date format".localized
		dateFormatter.dateFormat = format
		return dateFormatter.string(from: self)
	}
}
