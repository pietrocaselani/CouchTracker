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

final class SearchBarView: UISearchBar, SearchView {
  var presenter: SearchPresenterLayer!

  func showHint(message: String) {
    self.placeholder = message
  }

  override func didMoveToSuperview() {
    super.didMoveToSuperview()

    self.delegate = self

    presenter.viewDidLoad()
  }
}

extension SearchBarView: UISearchBarDelegate {
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    searchBar.setShowsCancelButton(true, animated: true)
  }

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    if let query = searchBar.text {
      presenter.searchMovies(query: query)
    }
  }

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.text = nil
    searchBar.setShowsCancelButton(false, animated: true)
    searchBar.resignFirstResponder()
    presenter.cancelSearch()
  }
}
