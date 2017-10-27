import Foundation
import RxSwift
import ObjectMapper
import Moya

extension Data {

  func toJSON() throws -> Any {
    return try JSONSerialization.jsonObject(with: self, options: .allowFragments)
  }

  func mapObject<T: ImmutableMappable>(_ type: T.Type) throws -> T {
    let json = try toJSON()
    return try Mapper<T>().map(JSONObject: json)
  }

  func mapArray<T: ImmutableMappable>(_ type: T.Type) throws -> [T] {
    guard let json = try toJSON() as? [[String: Any]] else {
      throw MapError(key: nil, currentValue: nil, reason: nil)
    }
    return try Mapper<T>().mapArray(JSONArray: json)
  }

}

extension NSData {

  func toJSON() throws -> Any {
    return try (self as Data).toJSON()
  }

  func mapObject<T: ImmutableMappable>(_ type: T.Type) throws -> T {
    return try (self as Data).mapObject(type)
  }

  func mapArray<T: ImmutableMappable>(_ type: T.Type) throws -> [T] {
    return try (self as Data).mapArray(type)
  }

}

extension ObservableType where E == Data {

  func mapObject<T: ImmutableMappable>(_ type: T.Type) -> Observable<T> {
    return flatMap { data -> Observable<T> in
      return Observable.just(try data.mapObject(type))
    }
  }

  func mapArray<T: ImmutableMappable>(_ type: T.Type) -> Observable<[T]> {
    return flatMap { data -> Observable<[T]> in
      return Observable.just(try data.mapArray(type))
    }
  }

}

extension ObservableType where E == NSData {

  func mapObject<T: ImmutableMappable>(_ type: T.Type) -> Observable<T> {
    return flatMap { data -> Observable<T> in
      return Observable.just(try data.mapObject(type))
    }
  }

  func mapArray<T: ImmutableMappable>(_ type: T.Type) -> Observable<[T]> {
    return flatMap { data -> Observable<[T]> in
      return Observable.just(try data.mapArray(type))
    }
  }

}
