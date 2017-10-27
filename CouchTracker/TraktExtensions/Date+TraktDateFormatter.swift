import Foundation
import Trakt

extension Date {
  func parse(using formatter: DateFormatter = TraktDateTransformer.dateTransformer.dateFormatter) -> String {
    return formatter.string(from: self)
  }
}
