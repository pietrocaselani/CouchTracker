extension Sequence where Element == Extended {
  public func separatedByComma() -> String {
    self.map { $0.rawValue }.joined(separator: ",")
  }
}
