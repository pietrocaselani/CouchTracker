import SnapshotTesting

extension Snapshotting where Value: Encodable, Format == String {
  public static var unsortedJSON: Snapshotting {
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted]
    return .json(encoder)
  }
}
