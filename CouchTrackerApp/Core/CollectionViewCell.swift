open class CollectionViewCell: UICollectionViewCell {
  public override init(frame: CGRect) {
    super.init(frame: frame)
    initialize()
    installConstraints()
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initialize()
    installConstraints()
  }

  open func initialize() {}

  open func installConstraints() {}
}
