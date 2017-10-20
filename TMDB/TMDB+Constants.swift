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

import Foundation

extension TMDB {
  public static let baseURL = URL(string: "https://\(TMDB.apiHost)/\(TMDB.apiVersion)")!

  static let apiHost = "api.themoviedb.org"
  static let apiVersion = "3"
  static let defaultSecureImageURL = "https://image.tmdb.org/t/p/"
  static let defaultBackdropSizes = ["w300", "w780", "w1280", "original"]
  static let defaultPosterSizes = ["w92", "w154", "w185", "w342", "w500", "w780", "original"]
  static let defaultStillSizes = ["w92", "w185", "w300", "original"]
}
