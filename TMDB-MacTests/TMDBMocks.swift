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

private func toObject(data: Data) -> [String: AnyObject] {
  let options = JSONSerialization.ReadingOptions(rawValue: 0)
  return try! JSONSerialization.jsonObject(with: data, options: options) as! [String: AnyObject]
}

private func toArray(data: Data) -> [[String: AnyObject]] {
  let options = JSONSerialization.ReadingOptions(rawValue: 0)
  return try! JSONSerialization.jsonObject(with: data, options: options) as! [[String: AnyObject]]
}

func createConfigurationsMock() -> Configuration {
  let jsonObject = toObject(data: ConfigurationService.configuration.sampleData)
  return try! Configuration(JSON: jsonObject)
}

func createMovieImagesMock() -> Images {
  let jsonObject = toObject(data: Movies.images(movieId: 23).sampleData)
  return try! Images(JSON: jsonObject)
}
