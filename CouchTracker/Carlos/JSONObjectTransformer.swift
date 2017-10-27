import Carlos
import PiedPiper
import ObjectMapper

final class JSONObjectTransfomer<T: ImmutableMappable>: TwoWayTransformer {
  typealias TypeIn = NSData
  typealias TypeOut = T

  func transform(_ val: NSData) -> Future<T> {
    let result = Promise<T>()

    do {
      let object = try val.mapObject(T.self)
      result.succeed(object)
    } catch {
      result.fail(error)
    }

    return result.future
  }

  func inverseTransform(_ val: T) -> Future<NSData> {
    let result = Promise<NSData>()

    let options = JSONSerialization.WritingOptions(rawValue: 0)

    do {
      let data = try JSONSerialization.data(withJSONObject: val.toJSON(), options: options)
      result.succeed(data as NSData)
    } catch {
      result.fail(error)
    }

    return result.future
  }
}
