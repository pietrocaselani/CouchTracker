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

import Carlos
import PiedPiper
import ObjectMapper

final class JSONArrayTransfomer<T: ImmutableMappable>: TwoWayTransformer {
  typealias TypeIn = NSData
  typealias TypeOut = [T]

  func transform(_ val: TypeIn) -> Future<TypeOut> {
    let result = Promise<TypeOut>()

    do {
      let array = try val.mapArray(T.self)
      result.succeed(array)
    } catch {
      result.fail(error)
    }

    return result.future
  }

  func inverseTransform(_ val: TypeOut) -> Future<TypeIn> {
    let result = Promise<NSData>()

    let options = JSONSerialization.WritingOptions(rawValue: 0)

    do {
      let data = try JSONSerialization.data(withJSONObject: val.toJSON(), options: options)
      result.succeed(data as TypeIn)
    } catch {
      result.fail(error)
    }

    return result.future
  }
}
