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

import Moya

public protocol TraktType: TargetType, Hashable {}

public extension TraktType {

  public var baseURL: URL { return Trakt.baseURL }

  public var method: Moya.Method { return .get }

  public var parameterEncoding: ParameterEncoding { return URLEncoding.default }

  public var task: Task { return .request }

  public var sampleData: Data {
    return "".utf8Encoded
  }

  public var hashValue: Int {
    let typeName = String(reflecting: self)

    var hash = typeName.hashValue ^ path.hashValue ^ method.hashValue

    parameters?.forEach { (key, _) in
      hash ^= key.hashValue
    }

    return hash
  }

  public static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}

func stubbedResponse(_ filename: String) -> Data {
  let resourcesPath = Bundle(for: Trakt.self).bundlePath
  let bundle = Bundle(path: resourcesPath.appending("/../Trakt-Tests-Resources.bundle"))!
  guard let url = bundle.url(forResource: filename, withExtension: "json"),
    let data = try? Data(contentsOf: url) else {
      return Data()
  }

  return data
}
