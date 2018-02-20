import Foundation
import TraktSwift

extension Date {
	func parse(using formatter: DateFormatter = TraktDateTransformer.dateTransformer.dateFormatter) -> String {
		return formatter.string(from: self)
	}
}
