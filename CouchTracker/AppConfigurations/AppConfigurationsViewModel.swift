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

struct AppConfigurationsViewModel: Hashable {
  let title: String
  let configurations: [AppConfigurationViewModel]

  var hashValue: Int {
    var hash = title.hashValue

    configurations.forEach { hash ^= $0.hashValue }

    return hash
  }

  static func == (lhs: AppConfigurationsViewModel, rhs: AppConfigurationsViewModel) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}

struct AppConfigurationViewModel: Hashable {
  let title: String
  let subtitle: String?

  var hashValue: Int {
    var hash = title.hashValue

    if let subtitleHash = subtitle?.hashValue {
      hash ^= subtitleHash
    }

    return hash
  }

  static func == (lhs: AppConfigurationViewModel, rhs: AppConfigurationViewModel) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
