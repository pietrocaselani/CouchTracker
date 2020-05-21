public func zip<A, B>(_ a: A?, _ b: B?) -> (A, B)? {
  guard let aData = a else { return nil }
  guard let bData = b else { return nil }
  return (aData, bData)
}
