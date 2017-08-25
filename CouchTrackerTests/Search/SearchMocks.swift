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

import RxSwift
import ObjectMapper

final class EmptySearchStoreMock: SearchStoreInput {
  func search(query: String, types: [SearchType]) -> RxSwift.Observable<[SearchResult]> {
    return Observable.empty()
  }
}

final class SearchStoreMock: SearchStoreInput {
  private let results: [SearchResult]

  init(results: [SearchResult]) {
    self.results = results
  }

  func search(query: String, types: [SearchType]) -> Observable<[SearchResult]> {
    return Observable.just(results)
  }
}

func createSearchResultsMock() -> [SearchResult] {
  let data = Search.textQuery(types: [.movie], query: "Tron").sampleData
  let options = JSONSerialization.ReadingOptions(rawValue: 0)

  let array = try! JSONSerialization.jsonObject(with: data, options: options) as! [[String: AnyObject]]

  return array.map { ObjectMapper.Map(mappingType: .fromJSON, JSON: $0) }.map { try! SearchResult(map: $0) }
}
