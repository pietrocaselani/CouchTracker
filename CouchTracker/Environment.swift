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

import TraktSwift
import TMDBSwift

final class Environment {
  static let instance = Environment()
  let trakt: TraktProvider
  let tmdb: TMDBProvider
  let loginObservable: TraktLoginObservable
  let defaultOutput: TraktLoginOutput

  private init() {
    self.trakt = Trakt(clientId: TraktSecrets.clientId,
                       clientSecret: TraktSecrets.clientSecret,
                       redirectURL: TraktSecrets.redirectURL)
    self.tmdb = TMDB(apiKey: TMDBSecrets.apiKey)

    let traktLoginStore = TraktLoginStore(trakt: trakt)

    self.loginObservable = traktLoginStore
    self.defaultOutput = traktLoginStore.loginOutput
  }
}
