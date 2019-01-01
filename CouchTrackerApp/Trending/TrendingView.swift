import Cartography

public final class TrendingView: View {
  public let collectionView: UICollectionView
  public let emptyView = DefaultEmptyView()

  init(collectionViewLayout: UICollectionViewLayout = UICollectionViewLayout.ctDefault) {
    collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewLayout)
    super.init()
  }

  public required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public required init() {
    fatalError("init() has not been implemented")
  }

  public override func initialize() {
    addSubview(collectionView)
    addSubview(emptyView)
  }

  public override func installConstraints() {
    constrain(collectionView, emptyView) { collectionView, empty in
      collectionView.top == collectionView.superview!.top
      collectionView.bottom == collectionView.superview!.bottom
      collectionView.left == collectionView.superview!.left
      collectionView.right == collectionView.superview!.right

      empty.center == empty.superview!.center
    }
  }
}
