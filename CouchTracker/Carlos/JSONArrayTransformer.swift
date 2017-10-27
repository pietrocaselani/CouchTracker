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
