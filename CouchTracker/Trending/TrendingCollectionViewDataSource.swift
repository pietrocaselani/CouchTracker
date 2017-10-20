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

final class TrendingCollectionViewDataSource: NSObject, TrendingDataSource, UICollectionViewDataSource {
  var viewModels = [TrendingViewModel]()

  private let imageRepository: ImageRepository

  init(imageRepository: ImageRepository) {
    self.imageRepository = imageRepository
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModels.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let identifier = R.reuseIdentifier.trendingCell

    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) else {
      fatalError("cell isn't an instance of TrendingCell.")
    }

    let viewModel = viewModels[indexPath.row]
    let interactor = TrendingCellService(imageRepository: imageRepository)
    let presenter = TrendingCelliOSPresenter(view: cell, interactor: interactor, viewModel: viewModel)

    cell.presenter = presenter

    return cell
  }
}
