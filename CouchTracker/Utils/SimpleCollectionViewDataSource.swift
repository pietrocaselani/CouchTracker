/*
 Copyright 2017 ArcTouch LLC.
 All rights reserved.

 This file, its contents, concepts, methods, behavior, and operation
 (collectively the "Software") are protected by trade secret, patent,
 and copyright laws. The use of the Software is governed by a license
 agreement. Disclosure of the Software to third parties, in any form,
 in whole or in part, is expressly prohibited except as authorized by
 the license agreement.
 */

import UIKit

final class SimpleCollectionViewDataSource<E>: NSObject, UICollectionViewDataSource {

  public typealias CellFactory = (UICollectionView, IndexPath, E) -> UICollectionViewCell

  var elements = [E]()

  private let cellFactory: CellFactory

  init(cellFactory: @escaping CellFactory) {
    self.cellFactory = cellFactory
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return elements.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    return cellFactory(collectionView, indexPath, elements[indexPath.row])
  }

}
