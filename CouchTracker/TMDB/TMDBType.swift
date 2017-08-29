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

public protocol TMDBType: TargetType {}

public extension TMDBType {
  public var baseURL: URL { return TMDB.baseURL }

  public var method: Moya.Method { return .get }

  public var parameterEncoding: ParameterEncoding { return URLEncoding.default }

  public var task: Task { return .request }

  public var sampleData: Data { return "".utf8Encoded }
}
