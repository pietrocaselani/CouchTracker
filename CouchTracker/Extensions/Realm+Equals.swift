import Realm

extension RLMArray {
  open override func isEqual(_ object: Any?) -> Bool {
    guard let otherArray = object as? RLMArray else { return false }

    guard self.count == otherArray.count else { return false }

    let count = self.count
    var equals = true
    var index: UInt = 0

    while index < count && equals {
      guard let lhs = self.object(at: index) as? RLMObject else { return false }
      guard let rhs = otherArray.object(at: index) as? RLMObject else { return false }

      equals = lhs == rhs
      index += 1
    }

    return equals
  }

}
