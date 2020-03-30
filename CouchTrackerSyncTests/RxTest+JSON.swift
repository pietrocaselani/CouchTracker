import RxSwift
import RxTest

extension Recorded: Encodable where Value: Encodable {
  private enum CodingKeys: CodingKey {
    case time
    case value
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(time, forKey: .time)
    try container.encode(value, forKey: .value)
  }
}

extension Event: Encodable where Element: Encodable {
  private enum CodingKeys: CodingKey {
    case next
  }

  public func encode(to encoder: Encoder) throws {
    switch self {
    case let .next(value):
      var container = encoder.singleValueContainer()
      try container.encode(ElementWrapper(element: value))
    case .completed:
      var container = encoder.singleValueContainer()
      try container.encode("completed")
    case let .error(error):
      var container = encoder.singleValueContainer()
      try container.encode(String(describing: error))
    }
  }
}

private struct ClassNameKey: CodingKey {
  var stringValue: String
  var intValue: Int?

  init(stringValue: String) {
    self.stringValue = stringValue
  }

  init?(intValue: Int) {
    nil
  }
}

private struct ElementWrapper<Element: Encodable>: Encodable {
  private let classNameKey: ClassNameKey
  private let element: Element

  fileprivate init(element: Element) {
    self.element = element
    self.classNameKey = ClassNameKey(stringValue: String(describing: Element.self))
  }

  fileprivate func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: ClassNameKey.self)

    try container.encode(element, forKey: classNameKey)
  }
}
