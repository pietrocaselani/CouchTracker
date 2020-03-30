public enum Fonts {
  public static let primaryText = UIFont.systemFont(ofSize: Sizes.primaryText)
  public static let secondaryText = UIFont.systemFont(ofSize: Sizes.secondaryText)
  public static let titleBold = bold(ofSize: Sizes.title)
  public static func bold(ofSize size: CGFloat = UIFont.labelFontSize) -> UIFont {
    UIFont.boldSystemFont(ofSize: size)
  }

  public enum Sizes {
    public static let primaryText: CGFloat = 20
    public static let secondaryText = UIFont.labelFontSize
    public static let title: CGFloat = 26
  }
}
