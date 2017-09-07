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

final class ShowDetailsService: ShowDetailsInteractor {
  private let repository: ShowDetailsRepository

  init(repository: ShowDetailsRepository) {
    self.repository = repository
  }

  func fetchDetailsOfShow(with identifier: String) -> Single<ShowEntity> {
    return repository.fetchDetailsOfShow(with: identifier, extended: .full).map { ShowEntityMapper.entity(for: $0) }
  }
}
