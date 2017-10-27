import Foundation

final class JSONParser {
  static func toArray(data: Data) -> [[String: AnyObject]] {
    return toJSON(data: data) as! [[String: AnyObject]]
  }

  static func toObject(data: Data) -> [String: AnyObject] {
    return toJSON(data: data) as! [String: AnyObject]
  }

  static func toJSON(data: Data) -> Any {
    let options = JSONSerialization.ReadingOptions(rawValue: 0)
    return try! JSONSerialization.jsonObject(with: data, options: options)
  }
}
