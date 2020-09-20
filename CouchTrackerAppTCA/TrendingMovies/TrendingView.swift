import UIKit

final class TrendingView: View {
  public let collectionView: UICollectionView

  init(collectionViewLayout: UICollectionViewLayout = UICollectionViewLayout.ctDefault) {
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    super.init()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @available(*, unavailable)
  required init() {
    fatalError("init() has not been implemented")
  }

  override func initialize() {
    backgroundColor = Colors.View.background
    collectionView.backgroundColor = Colors.View.background

    addSubview(collectionView)
  }

  override func installConstraints() {
    collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
  }
}
