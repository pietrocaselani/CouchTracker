import Foundation

extension Date {
	public func shortString() -> String {
		let dateFormatter = DateFormatter()
		let format = "short date format".localized
		dateFormatter.dateFormat = format
		dateFormatter.timeZone = NSTimeZone.system
		return dateFormatter.string(from: self)
	}
}
