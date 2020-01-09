protocol DataStruct: Hashable {}

extension DataStruct {
  func setValueOptional<T>(_ value: OptionalCopyValue<T>, _ defaultValue: T?) -> T? {
    switch value {
    case let .new(content):
      return content
    case .same:
      return defaultValue
    default:
      return nil
    }
  }

  func setValue<T>(_ value: CopyValue<T>, _ defaultValue: T) -> T {
    switch value {
    case let .new(content):
      return content
    case .same:
      return defaultValue
    }
  }
}

enum OptionalCopyValue<T> {
  case new(T)
  case same
  case `nil`
}

enum CopyValue<T> {
  case new(T)
  case same
}
