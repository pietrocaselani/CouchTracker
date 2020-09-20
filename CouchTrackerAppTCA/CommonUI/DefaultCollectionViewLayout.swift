import UIKit

extension UICollectionViewLayout {
  static var ctDefault: UICollectionViewLayout {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.itemSize = CGSize(width: 100, height: 180)
    layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    layout.minimumInteritemSpacing = 5
    layout.minimumLineSpacing = 5
    return layout
  }
}
