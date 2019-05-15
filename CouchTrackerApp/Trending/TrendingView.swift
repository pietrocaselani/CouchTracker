import SnapKit

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
    collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }

    emptyView.snp.makeConstraints { $0.center.equalToSuperview() }
  }
}
