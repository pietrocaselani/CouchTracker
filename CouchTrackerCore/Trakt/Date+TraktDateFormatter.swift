import Foundation
import TraktSwift

extension Date {
  public func parse(using formatter: DateFormatter = TraktDateTransformer.dateTransformer.dateFormatter) -> String {
    formatter.string(from: self)
  }
}
