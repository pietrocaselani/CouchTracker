extension EpisodeEntity {
  public func seasonAndNumberFormatted() -> String {
    var numberText = String(number)

    if numberText.count == 1 {
      numberText.insert("0", at: numberText.startIndex)
    }

    var text = "\(season)x\(numberText)"

    if let absoluteNumber = absoluteNumber {
      text.append(" (\(absoluteNumber))")
    }

    return text
  }
}
