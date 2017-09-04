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

final class SearchModule {

  private init() {}

  static func setupModule(traktProvider: TraktProvider, resultsOutput: SearchResultOutput) -> SearchView {
    guard let searchView = R.nib.searchBarView.firstView(owner: nil) else {
      fatalError("searchView should be an instance of SearchView")
    }

    let store = APISearchRepository(traktProvider: traktProvider)
    let interactor = SearchService(repository: store)
    let presenter = SearchiOSPresenter(view: searchView, interactor: interactor, resultOutput: resultsOutput)

    searchView.presenter = presenter

    return searchView
  }
}
