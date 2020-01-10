extension Sequence where Element == Extended {
  public func separatedByComma() -> String {
    return self.map { $0.rawValue }.joined(separator: ",")
  }
}
