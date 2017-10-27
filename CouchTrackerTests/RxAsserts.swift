import RxSwift
import RxTest
import XCTest

func RXAssertEvents<T:Equatable>(_ observer: TestableObserver<[T]>, _ events: [Recorded<Event<[T]>>]) {
  XCTAssertEqual(observer.events.count, events.count)

  if (observer.events.count != events.count) {
    XCTFail("Number of events don't match")
    return
  }

  let count = events.count
  var index = 0

  while index < count {
    let lhs = observer.events[index]
    let rhs = events[index]

    XCTAssertEqual(lhs.time, lhs.time)

    assertArrayEvent(lhs.value, rhs.value)

    index += 1
  }
}

fileprivate func assertArrayEvent<T:Equatable>(_ lhs: Event<[T]>, _ rhs: Event<[T]>) {
  XCTAssertEqual(lhs.error?.localizedDescription, rhs.error?.localizedDescription)
  XCTAssertEqual(lhs.isCompleted, rhs.isCompleted)

  let lhsElement = lhs.element
  let rhsElement = rhs.element

  XCTAssertEqual(lhsElement?.count, rhsElement?.count)

  let count = lhsElement?.count ?? 0
  var index = 0

  while index < count {
    let lhsValue = lhsElement![index]
    let rhsValue = rhsElement![index]

    XCTAssertEqual(lhsValue, rhsValue)

    index += 1
  }
}
